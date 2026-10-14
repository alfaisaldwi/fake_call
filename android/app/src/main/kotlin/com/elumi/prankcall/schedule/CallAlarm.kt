package com.elumi.prankcall.schedule

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONObject

object CallAlarm {
    const val ACTION_RING = "com.elumi.prankcall.RING_SCHEDULED_CALL"
    const val EXTRA_ID = "scheduled_call_id"
    private const val REQUEST_CODE = 7301

    fun schedule(context: Context, payload: String) {
        val json = JSONObject(payload)
        val id = json.getString("id")
        val ringsAt = json.getLong("ringsAt")
        ScheduledCallStore(context).savePending(payload)
        val manager = context.getSystemService(AlarmManager::class.java) ?: return
        val operation = operation(context, id)
        if (canScheduleExact(context)) {
            manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, ringsAt, operation)
        } else {
            manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, ringsAt, operation)
        }
    }

    fun cancel(context: Context, id: String) {
        val store = ScheduledCallStore(context)
        if (ScheduledCallStore.idOf(store.pending()) != id) return
        store.clearPending(id)
        context.getSystemService(AlarmManager::class.java)?.cancel(operation(context, id))
    }

    fun canScheduleExact(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        return context.getSystemService(AlarmManager::class.java)?.canScheduleExactAlarms() ?: false
    }

    private fun operation(context: Context, id: String): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            Intent(context, CallAlarmReceiver::class.java)
                .setAction(ACTION_RING)
                .putExtra(EXTRA_ID, id),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
}
