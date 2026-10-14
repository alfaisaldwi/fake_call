package com.elumi.prankcall.schedule

import android.content.Context
import io.flutter.plugin.common.MethodChannel

object CallDispatcher {
    private const val METHOD_FIRED = "alarmFired"

    var mainChannel: MethodChannel? = null
    var backgroundChannel: MethodChannel? = null

    fun dispatch(context: Context, payload: String) {
        val channel = mainChannel ?: backgroundChannel
        if (channel == null) {
            BackgroundCallEngine.start(context)
            return
        }
        channel.invokeMethod(
            METHOD_FIRED,
            payload,
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    ScheduledCallStore(context).takeDue()
                }

                override fun error(code: String, message: String?, details: Any?) {
                    fallBack(context, channel)
                }

                override fun notImplemented() {
                    fallBack(context, channel)
                }
            },
        )
    }

    private fun fallBack(context: Context, failed: MethodChannel) {
        if (failed === backgroundChannel) return
        BackgroundCallEngine.start(context)
    }
}
