package com.elumi.prankcall.quick

import android.content.Context
import android.content.Intent
import com.elumi.prankcall.MainActivity

object QuickCall {
    const val ACTION = "com.elumi.prankcall.QUICK_CALL"
    const val EXTRA_DELAY = "delay_seconds"
    const val TILE_DELAY = 10

    fun intent(context: Context, delaySeconds: Int): Intent =
        Intent(context, MainActivity::class.java)
            .setAction(ACTION)
            .putExtra(EXTRA_DELAY, delaySeconds)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)

    fun delayOf(intent: Intent?): Int? {
        if (intent?.action != ACTION) return null
        return intent.getIntExtra(EXTRA_DELAY, TILE_DELAY)
    }
}
