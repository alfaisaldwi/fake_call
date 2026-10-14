package com.elumi.prankcall.bridge

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import com.elumi.prankcall.incoming.RingVibrator
import com.elumi.prankcall.notification.MissedCallNotifier
import com.elumi.prankcall.schedule.CallAlarm
import com.elumi.prankcall.schedule.ScheduledCallStore
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException

object NativeChannels {
    private const val MISSED_CALL_CHANNEL = "com.elumi.prankcall/missed_call"
    private const val RING_VIBRATION_CHANNEL = "com.elumi.prankcall/ring_vibration"
    private const val CALL_ALARM_CHANNEL = "com.elumi.prankcall/call_alarm"
    private const val POWER_CHANNEL = "com.elumi.prankcall/power"

    fun attach(
        engine: FlutterEngine,
        context: Context,
        onRelease: (() -> Unit)? = null,
    ): MethodChannel {
        val messenger = engine.dartExecutor.binaryMessenger
        val notifier = MissedCallNotifier(context)
        MethodChannel(messenger, MISSED_CALL_CHANNEL).setMethodCallHandler { call, result ->
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
        val ringVibrator = RingVibrator(context)
        MethodChannel(messenger, RING_VIBRATION_CHANNEL).setMethodCallHandler { call, result ->
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
        MethodChannel(messenger, POWER_CHANNEL).setMethodCallHandler { call, result ->
            handlePower(context, call, result)
        }
        return MethodChannel(messenger, CALL_ALARM_CHANNEL).also { channel ->
            channel.setMethodCallHandler { call, result ->
                handleAlarm(context, call, result, onRelease)
            }
        }
    }

    private fun handleAlarm(
        context: Context,
        call: MethodCall,
        result: MethodChannel.Result,
        onRelease: (() -> Unit)?,
    ) {
        val store = ScheduledCallStore(context)
        when (call.method) {
            "schedule" -> {
                val payload = call.arguments as? String
                if (payload == null) {
                    result.error("invalid_payload", "Missing payload", null)
                    return
                }
                try {
                    CallAlarm.schedule(context, payload)
                    result.success(null)
                } catch (e: JSONException) {
                    result.error("invalid_payload", e.message, null)
                } catch (e: SecurityException) {
                    result.error("alarm_denied", e.message, null)
                }
            }
            "cancel" -> {
                (call.arguments as? String)?.let { CallAlarm.cancel(context, it) }
                result.success(null)
            }
            "pending" -> result.success(store.pending())
            "takeDue" -> result.success(store.takeDue())
            "release" -> {
                result.success(null)
                onRelease?.let { Handler(Looper.getMainLooper()).post(it) }
            }
            else -> result.notImplemented()
        }
    }

    private fun handlePower(context: Context, call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "canScheduleExact" -> result.success(CallAlarm.canScheduleExact(context))
            "isBatteryUnrestricted" -> {
                val power = context.getSystemService(PowerManager::class.java)
                result.success(power?.isIgnoringBatteryOptimizations(context.packageName) ?: true)
            }
            "openExactAlarmSettings" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    open(context, Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                }
                result.success(null)
            }
            "openBatterySettings" -> {
                open(context, Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun open(context: Context, action: String) {
        val intent = Intent(action, Uri.fromParts("package", context.packageName, null))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
