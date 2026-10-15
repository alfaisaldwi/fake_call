package com.elumi.fakecalling.incoming

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.os.Build
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

class RingVibrator(private val context: Context) {

    private val vibrator: Vibrator? by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java)?.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }
    }

    fun start() {
        val device = vibrator ?: return
        if (!device.hasVibrator() || isSilent()) return
        val effect = VibrationEffect.createWaveform(TIMINGS, AMPLITUDES, REPEAT_FROM)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            device.vibrate(
                effect,
                VibrationAttributes.createForUsage(VibrationAttributes.USAGE_ALARM),
            )
        } else {
            @Suppress("DEPRECATION")
            device.vibrate(
                effect,
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
        }
    }

    fun stop() {
        vibrator?.cancel()
    }

    private fun isSilent(): Boolean {
        val audio = context.getSystemService(AudioManager::class.java) ?: return false
        return audio.ringerMode == AudioManager.RINGER_MODE_SILENT
    }

    private companion object {
        val TIMINGS = longArrayOf(0, 1000, 1000)
        val AMPLITUDES = intArrayOf(0, VibrationEffect.DEFAULT_AMPLITUDE, 0)
        const val REPEAT_FROM = 0
    }
}
