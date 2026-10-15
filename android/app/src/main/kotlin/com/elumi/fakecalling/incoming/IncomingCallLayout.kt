package com.elumi.fakecalling.incoming

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.PopupMenu
import android.widget.TextView
import com.elumi.fakecalling.R

class IncomingCallLayout @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : FrameLayout(context, attrs) {

    override fun onFinishInflate() {
        super.onFinishInflate()
        val isVideo = IncomingCallInfo.isVideoCall(context)
        IncomingCallInfo.isVideoOff = false
        applyVisibility(this, isVideo)
        findViewById<TextView>(R.id.tvToggleVideo)?.setOnClickListener { toggleVideo(it as TextView) }
        findViewById<View>(R.id.flMessage)?.setOnClickListener(::showQuickReplies)
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

    private fun toggleVideo(pill: TextView) {
        val videoOff = !IncomingCallInfo.isVideoOff
        IncomingCallInfo.isVideoOff = videoOff
        findViewById<FrontCameraPreviewView>(R.id.vFrontCamera)?.setPreviewPaused(videoOff)
        pill.setText(
            if (videoOff) R.string.fwc_incoming_turn_on_video else R.string.fwc_incoming_turn_off_video,
        )
        pill.setCompoundDrawablesRelativeWithIntrinsicBounds(
            if (videoOff) R.drawable.fwc_ic_videocam else R.drawable.fwc_ic_videocam_off,
            0,
            0,
            0,
        )
    }

    private fun showQuickReplies(anchor: View) {
        val replies = resources.getStringArray(R.array.fwc_quick_replies)
        PopupMenu(context, anchor).apply {
            replies.forEachIndexed { index, reply -> menu.add(0, index, index, reply) }
            setOnMenuItemClickListener {
                findViewById<View>(R.id.ivDeclineCall)?.performClick()
                true
            }
        }.show()
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
