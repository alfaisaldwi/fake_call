package com.elumi.fakecalling.widget

import android.content.Context
import com.elumi.fakecalling.schedule.CallAlarm
import org.json.JSONException
import org.json.JSONObject
import java.util.UUID

internal object WidgetCall {
    private const val FLUTTER_PREFS = "FlutterSharedPreferences"
    private const val LAST_CONFIG_KEY = "flutter.last_call_config"

    fun schedule(context: Context, delaySeconds: Int): Boolean {
        val raw = context.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            .getString(LAST_CONFIG_KEY, null) ?: return false
        return try {
            val config = JSONObject(raw)
            if (config.optString("callerName").isBlank()) return false
            config.put("delayInSeconds", delaySeconds)
            config.remove("ringAt")
            val now = System.currentTimeMillis()
            val payload = JSONObject()
                .put("id", UUID.randomUUID().toString())
                .put("config", config)
                .put("scheduledAt", now)
                .put("ringsAt", now + delaySeconds * 1000L)
            CallAlarm.schedule(context, payload.toString())
            true
        } catch (_: JSONException) {
            false
        }
    }
}
