package com.elumi.fakecalling.incoming

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Matrix
import android.graphics.RectF
import android.graphics.SurfaceTexture
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import android.os.Handler
import android.os.HandlerThread
import android.util.AttributeSet
import android.util.Log
import android.util.Size
import android.view.Surface
import android.view.TextureView
import kotlin.math.max

class FrontCameraPreviewView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : TextureView(context, attrs), TextureView.SurfaceTextureListener {

    private val enabled = IncomingCallInfo.isVideoCall(context)
    private var thread: HandlerThread? = null
    private var handler: Handler? = null
    private var device: CameraDevice? = null
    private var session: CameraCaptureSession? = null
    private var previewSize: Size? = null
    private var revealed = false
    private var paused = false

    init {
        alpha = 0f
        surfaceTextureListener = this
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (!enabled) return
        thread = HandlerThread("FakeCallCamera").also { it.start() }
        handler = Handler(thread!!.looper)
        if (isAvailable) openCamera()
    }

    fun setPreviewPaused(paused: Boolean) {
        if (this.paused == paused) return
        this.paused = paused
        if (paused) {
            closeCamera()
            revealed = false
            animate().alpha(0f).setDuration(200).start()
        } else {
            openCamera()
        }
    }

    override fun onDetachedFromWindow() {
        closeCamera()
        thread?.quitSafely()
        thread = null
        handler = null
        super.onDetachedFromWindow()
    }

    override fun onSurfaceTextureAvailable(surface: SurfaceTexture, width: Int, height: Int) {
        if (enabled) openCamera()
    }

    override fun onSurfaceTextureSizeChanged(surface: SurfaceTexture, width: Int, height: Int) {
        applyCenterCrop()
    }

    override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean {
        closeCamera()
        return true
    }

    override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {
        if (revealed || paused) return
        revealed = true
        animate().alpha(1f).setDuration(250).start()
    }

    @SuppressLint("MissingPermission")
    private fun openCamera() {
        val cameraHandler = handler ?: return
        if (paused || device != null || !isAvailable) return
        if (context.checkSelfPermission(Manifest.permission.CAMERA) !=
            PackageManager.PERMISSION_GRANTED
        ) return
        val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            val cameraId = manager.cameraIdList.firstOrNull {
                manager.getCameraCharacteristics(it)
                    .get(CameraCharacteristics.LENS_FACING) ==
                    CameraCharacteristics.LENS_FACING_FRONT
            } ?: return
            previewSize = choosePreviewSize(manager.getCameraCharacteristics(cameraId))
            post { applyCenterCrop() }
            manager.openCamera(cameraId, deviceCallback, cameraHandler)
        } catch (e: CameraAccessException) {
            Log.w(TAG, "Front camera unavailable", e)
        } catch (e: SecurityException) {
            Log.w(TAG, "Camera permission missing", e)
        }
    }

    private val deviceCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(camera: CameraDevice) {
            if (!isAttachedToWindow || paused) {
                camera.close()
                return
            }
            device = camera
            startPreview(camera)
        }

        override fun onDisconnected(camera: CameraDevice) {
            camera.close()
            device = null
        }

        override fun onError(camera: CameraDevice, error: Int) {
            Log.w(TAG, "Camera error $error")
            camera.close()
            device = null
        }
    }

    @Suppress("DEPRECATION")
    private fun startPreview(camera: CameraDevice) {
        val texture = surfaceTexture ?: return
        val size = previewSize ?: return
        texture.setDefaultBufferSize(size.width, size.height)
        val surface = Surface(texture)
        try {
            val request = camera.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW).apply {
                addTarget(surface)
            }.build()
            camera.createCaptureSession(
                listOf(surface),
                object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(captureSession: CameraCaptureSession) {
                        if (device == null) return
                        session = captureSession
                        try {
                            captureSession.setRepeatingRequest(request, null, handler)
                        } catch (e: Exception) {
                            Log.w(TAG, "Preview request failed", e)
                        }
                    }

                    override fun onConfigureFailed(captureSession: CameraCaptureSession) {
                        Log.w(TAG, "Preview session failed")
                    }
                },
                handler,
            )
        } catch (e: Exception) {
            Log.w(TAG, "Preview start failed", e)
        }
    }

    private fun closeCamera() {
        try {
            session?.close()
        } catch (e: Exception) {
            Log.w(TAG, "Session close failed", e)
        }
        session = null
        device?.close()
        device = null
    }

    private fun choosePreviewSize(characteristics: CameraCharacteristics): Size? {
        val map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            ?: return null
        val sizes = map.getOutputSizes(SurfaceTexture::class.java) ?: return null
        return sizes
            .filter { it.width * it.height <= MAX_PREVIEW_PIXELS }
            .maxByOrNull { it.width * it.height }
            ?: sizes.minByOrNull { it.width * it.height }
    }

    private fun applyCenterCrop() {
        val size = previewSize ?: return
        if (width == 0 || height == 0) return
        val rotation = display?.rotation ?: Surface.ROTATION_0
        val portrait = rotation == Surface.ROTATION_0 || rotation == Surface.ROTATION_180
        val bufferWidth = if (portrait) size.height.toFloat() else size.width.toFloat()
        val bufferHeight = if (portrait) size.width.toFloat() else size.height.toFloat()
        val viewWidth = width.toFloat()
        val viewHeight = height.toFloat()
        val scale = max(viewWidth / bufferWidth, viewHeight / bufferHeight)
        val matrix = Matrix()
        val centerX = viewWidth / 2f
        val centerY = viewHeight / 2f
        if (portrait) {
            matrix.setScale(
                scale * bufferWidth / viewWidth,
                scale * bufferHeight / viewHeight,
                centerX,
                centerY,
            )
        } else {
            val viewRect = RectF(0f, 0f, viewWidth, viewHeight)
            val bufferRect = RectF(0f, 0f, size.height.toFloat(), size.width.toFloat())
            bufferRect.offset(centerX - bufferRect.centerX(), centerY - bufferRect.centerY())
            matrix.setRectToRect(viewRect, bufferRect, Matrix.ScaleToFit.FILL)
            val landscapeScale = max(viewHeight / size.height, viewWidth / size.width)
            matrix.postScale(landscapeScale, landscapeScale, centerX, centerY)
            matrix.postRotate(90f * (rotation - 2), centerX, centerY)
        }
        setTransform(matrix)
    }

    private companion object {
        const val TAG = "FrontCameraPreview"
        const val MAX_PREVIEW_PIXELS = 1920 * 1080
    }
}
