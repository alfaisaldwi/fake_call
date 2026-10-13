package com.elumi.prankcall.notification

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.BitmapShader
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Shader
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.elumi.prankcall.R
import java.io.File
import kotlin.math.max
import kotlin.math.min

class MissedCallNotifier(private val context: Context) {

    fun show(
        id: Int,
        title: String,
        body: String,
        channelName: String,
        avatarPath: String?,
        count: Int,
    ) {
        if (!canNotify()) return
        createChannel(channelName)
        val avatar = avatarPath?.let(::loadCircleAvatar)
        val content = RemoteViews(context.packageName, R.layout.fwc_missed_call_notification).apply {
            setTextViewText(R.id.fwc_missed_title, title)
            setTextViewText(R.id.fwc_missed_body, body)
            if (avatar != null) {
                setImageViewBitmap(R.id.fwc_missed_avatar, avatar)
                setViewVisibility(R.id.fwc_missed_avatar, View.VISIBLE)
            }
        }
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_missed_call)
            .setColor(ACCENT_COLOR)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(content)
            .setCustomBigContentView(content)
            .setCategory(NotificationCompat.CATEGORY_MISSED_CALL)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setShowWhen(true)
            .setWhen(System.currentTimeMillis())
            .setNumber(if (count > 1) count else 0)
            .setAutoCancel(true)
            .setContentIntent(launchIntent(id))
            .build()
        NotificationManagerCompat.from(context).notify(id, notification)
    }

    private fun canNotify(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) return false
        return NotificationManagerCompat.from(context).areNotificationsEnabled()
    }

    private fun createChannel(name: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_HIGH),
        )
    }

    private fun launchIntent(requestCode: Int): PendingIntent? {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: return null
        return PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun loadCircleAvatar(path: String): Bitmap? {
        if (!File(path).exists()) return null
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        val sample = max(1, min(bounds.outWidth, bounds.outHeight) / AVATAR_PX)
        val source = BitmapFactory.decodeFile(
            path,
            BitmapFactory.Options().apply { inSampleSize = sample },
        ) ?: return null
        val side = min(source.width, source.height)
        val square = Bitmap.createBitmap(
            source,
            (source.width - side) / 2,
            (source.height - side) / 2,
            side,
            side,
        )
        val scaled = Bitmap.createScaledBitmap(square, AVATAR_PX, AVATAR_PX, true)
        val output = Bitmap.createBitmap(AVATAR_PX, AVATAR_PX, Bitmap.Config.ARGB_8888)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            shader = BitmapShader(scaled, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP)
        }
        Canvas(output).drawCircle(AVATAR_PX / 2f, AVATAR_PX / 2f, AVATAR_PX / 2f, paint)
        return output
    }

    private companion object {
        const val CHANNEL_ID = "missed_calls"
        const val AVATAR_PX = 160
        const val ACCENT_COLOR = 0xFF008069.toInt()
    }
}
