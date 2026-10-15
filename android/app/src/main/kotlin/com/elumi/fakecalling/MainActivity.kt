package com.elumi.fakecalling

import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.elumi.fakecalling.bridge.NativeChannels
import com.elumi.fakecalling.quick.QuickCall
import com.elumi.fakecalling.schedule.CallDispatcher
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingQuickDelay: Int? = null
    private var quickCallChannel: MethodChannel? = null
    private var alarmChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        alarmChannel = NativeChannels.attach(flutterEngine, applicationContext).also {
            CallDispatcher.mainChannel = it
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
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        if (CallDispatcher.mainChannel === alarmChannel) CallDispatcher.mainChannel = null
        alarmChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
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
        const val QUICK_CALL_CHANNEL = "com.elumi.fakecalling/quick_call"
        const val ACTION_CALL_ACCEPT =
            "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT"
    }
}
