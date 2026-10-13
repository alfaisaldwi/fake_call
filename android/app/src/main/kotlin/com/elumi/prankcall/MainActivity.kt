package com.elumi.prankcall

import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.elumi.prankcall.notification.MissedCallNotifier
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
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
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applyCallWindowFlags(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        applyCallWindowFlags(intent)
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
        const val ACTION_CALL_ACCEPT =
            "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT"
    }
}
