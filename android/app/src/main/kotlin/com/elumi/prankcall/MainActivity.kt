package com.elumi.prankcall

import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.elumi.prankcall.incoming.RingVibrator
import com.elumi.prankcall.notification.MissedCallNotifier
import com.elumi.prankcall.quick.QuickCall
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingQuickDelay: Int? = null
    private var quickCallChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val notifier = MissedCallNotifier(applicationContext)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MISSED_CALL_CHANNEL,
        ).setMethodCallHandler { call, result ->
            if (call.method != "showMissedCall") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            notifier.show(
                id = call.argument<Int>("id") ?: 0,
                title = call.argument<String>("title").orEmpty(),
                body = call.argument<String>("body").orEmpty(),
                channelName = call.argument<String>("channelName").orEmpty(),
                avatarPath = call.argument<String>("avatarPath"),
                count = call.argument<Int>("count") ?: 1,
            )
            result.success(null)
        }
        quickCallChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            QUICK_CALL_CHANNEL,
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                if (call.method != "takePending") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                result.success(pendingQuickDelay)
                pendingQuickDelay = null
            }
        }
        val ringVibrator = RingVibrator(applicationContext)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            RING_VIBRATION_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> ringVibrator.start()
                "stop" -> ringVibrator.stop()
                else -> {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
            }
            result.success(null)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applyCallWindowFlags(intent)
        pendingQuickDelay = QuickCall.delayOf(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        applyCallWindowFlags(intent)
        QuickCall.delayOf(intent)?.let { delay ->
            val channel = quickCallChannel
            if (channel == null) {
                pendingQuickDelay = delay
            } else {
                channel.invokeMethod("quickCall", delay)
            }
        }
    }

    private fun applyCallWindowFlags(intent: Intent?) {
        val isCallAccepted = intent?.action == ACTION_CALL_ACCEPT
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(isCallAccepted)
            setTurnScreenOn(isCallAccepted)
        }
    }

    private companion object {
        const val MISSED_CALL_CHANNEL = "com.elumi.prankcall/missed_call"
        const val RING_VIBRATION_CHANNEL = "com.elumi.prankcall/ring_vibration"
        const val QUICK_CALL_CHANNEL = "com.elumi.prankcall/quick_call"
        const val ACTION_CALL_ACCEPT =
            "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT"
    }
}
