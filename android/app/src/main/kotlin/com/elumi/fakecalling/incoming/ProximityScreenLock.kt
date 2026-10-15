package com.elumi.fakecalling.incoming

import android.content.Context
import android.os.PowerManager

class ProximityScreenLock(context: Context) {

    private val power = context.getSystemService(PowerManager::class.java)
    private var wakeLock: PowerManager.WakeLock? = null

    fun setEnabled(enabled: Boolean) {
        if (enabled) acquire() else release()
    }

    private fun acquire() {
        if (wakeLock?.isHeld == true) return
        val manager = power ?: return
        if (!manager.isWakeLockLevelSupported(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK)) return
        wakeLock = manager.newWakeLock(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK, TAG).apply {
            setReferenceCounted(false)
            acquire(MAX_HOLD_MS)
        }
    }

    private fun release() {
        wakeLock?.takeIf { it.isHeld }?.release(PowerManager.RELEASE_FLAG_WAIT_FOR_NO_PROXIMITY)
        wakeLock = null
    }

    private companion object {
        const val TAG = "fakecalling:proximity"
        const val MAX_HOLD_MS = 2 * 60 * 60 * 1000L
    }
}
