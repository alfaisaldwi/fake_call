package com.elumi.fakecalling.incoming

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import com.hiennv.flutter_callkit_incoming.CallkitConstants

internal object IncomingCallInfo {
    @Volatile
    var isVideoOff = false

    fun takeVideoOff(): Boolean = isVideoOff.also { isVideoOff = false }

    fun isVideoCall(context: Context): Boolean {
        val activity = context.findActivity() ?: return false
        val data = activity.intent?.extras
            ?.getBundle(CallkitConstants.EXTRA_CALLKIT_INCOMING_DATA)
        return (data?.getInt(CallkitConstants.EXTRA_CALLKIT_TYPE, 0) ?: 0) > 0
    }

    private tailrec fun Context.findActivity(): Activity? = when (this) {
        is Activity -> this
        is ContextWrapper -> baseContext.findActivity()
        else -> null
    }
}
