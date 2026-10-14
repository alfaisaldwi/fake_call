package com.elumi.prankcall.schedule

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager

class CallAlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != CallAlarm.ACTION_RING) return
        val id = intent.getStringExtra(CallAlarm.EXTRA_ID) ?: return
        val appContext = context.applicationContext
        val payload = ScheduledCallStore(appContext).markDue(id) ?: return
        keepAwake(appContext)
        CallDispatcher.dispatch(appContext, payload)
    }

    private fun keepAwake(context: Context) {
        context.getSystemService(PowerManager::class.java)
            ?.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, WAKE_LOCK_TAG)
            ?.apply { setReferenceCounted(false) }
            ?.acquire(WAKE_LOCK_MS)
    }

    private companion object {
        const val WAKE_LOCK_TAG = "FakeCall:ring"
        const val WAKE_LOCK_MS = 20_000L
    }
}
