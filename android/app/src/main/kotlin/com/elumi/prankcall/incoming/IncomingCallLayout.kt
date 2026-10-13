package com.elumi.prankcall.incoming

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.elumi.prankcall.R

class IncomingCallLayout @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : FrameLayout(context, attrs) {

    override fun onFinishInflate() {
        super.onFinishInflate()
        val isVideo = IncomingCallInfo.isVideoCall(context)
        applyVisibility(this, isVideo)
        findViewById<View>(R.id.ivAvatar)?.let { avatar ->
            val size = resources.getDimensionPixelSize(
                if (isVideo) R.dimen.fwc_avatar_video else R.dimen.fwc_avatar_voice,
            )
            avatar.layoutParams = avatar.layoutParams.apply {
                width = size
                height = size
            }
        }
    }

    private fun applyVisibility(view: View, isVideo: Boolean) {
        when (view.tag) {
            TAG_VIDEO_ONLY -> view.visibility = if (isVideo) VISIBLE else GONE
            TAG_VOICE_ONLY -> view.visibility = if (isVideo) GONE else VISIBLE
        }
        if (view is ViewGroup) {
            for (index in 0 until view.childCount) {
                applyVisibility(view.getChildAt(index), isVideo)
            }
        }
    }

    private companion object {
        const val TAG_VIDEO_ONLY = "video_only"
        const val TAG_VOICE_ONLY = "voice_only"
    }
}
