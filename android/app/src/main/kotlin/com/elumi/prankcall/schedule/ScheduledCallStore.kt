package com.elumi.prankcall.schedule

import android.content.Context
import org.json.JSONException
import org.json.JSONObject

internal class ScheduledCallStore(context: Context) {
    private val prefs = context.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun pending(): String? = prefs.getString(KEY_PENDING, null)

    fun savePending(payload: String) {
        prefs.edit().putString(KEY_PENDING, payload).commit()
    }

    fun clearPending(id: String) {
        if (idOf(pending()) == id) prefs.edit().remove(KEY_PENDING).commit()
    }

    fun markDue(id: String): String? {
        val payload = pending() ?: return null
        if (idOf(payload) != id) return null
        prefs.edit().remove(KEY_PENDING).putString(KEY_DUE, payload).commit()
        return payload
    }

    fun takeDue(): String? {
        val payload = prefs.getString(KEY_DUE, null) ?: return null
        prefs.edit().remove(KEY_DUE).commit()
        return payload
    }

    companion object {
        private const val FILE = "fwc_scheduled_call"
        private const val KEY_PENDING = "pending"
        private const val KEY_DUE = "due"

        fun idOf(payload: String?): String? = payload?.let {
            try {
                JSONObject(it).getString("id")
            } catch (_: JSONException) {
                null
            }
        }
    }
}
