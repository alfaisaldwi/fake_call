package com.elumi.fakecalling.incoming

import android.animation.ValueAnimator
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.Drawable
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.animation.DecelerateInterpolator
import android.view.animation.OvershootInterpolator
import android.widget.ImageView
import kotlin.math.max
import kotlin.math.min

class AcceptCallButton @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : ImageView(context, attrs) {

    private val density = resources.displayMetrics.density
    private val radius = 26f * density
    private val bounceHeight = 14f * density
    private val maxDrag = 120f * density
    private val acceptThreshold = 72f * density
    private val circlePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#1DAA61")
    }

    private var bounceOffset = 0f
    private var dragOffset = 0f
    private var touchStartY = 0f
    private var dragging = false
    private var accepted = false

    private val bounce = ValueAnimator.ofFloat(0f, -bounceHeight).apply {
        duration = 650
        repeatMode = ValueAnimator.REVERSE
        repeatCount = ValueAnimator.INFINITE
        interpolator = DecelerateInterpolator()
        addUpdateListener {
            bounceOffset = it.animatedValue as Float
            invalidate()
        }
    }
    private var release: ValueAnimator? = null

    override fun setBackground(background: Drawable?) {
        super.setBackground(null)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        bounce.start()
    }

    override fun onDetachedFromWindow() {
        bounce.cancel()
        release?.cancel()
        super.onDetachedFromWindow()
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (accepted) return true
        when (event.actionMasked) {
            MotionEvent.ACTION_DOWN -> startDrag(event.rawY)
            MotionEvent.ACTION_MOVE -> if (dragging) {
                dragOffset = max(-maxDrag, min(0f, event.rawY - touchStartY))
                invalidate()
            }
            MotionEvent.ACTION_UP -> finishDrag()
            MotionEvent.ACTION_CANCEL -> springBack()
        }
        return true
    }

    private fun startDrag(rawY: Float) {
        release?.cancel()
        bounce.pause()
        dragOffset = bounceOffset
        bounceOffset = 0f
        touchStartY = rawY - dragOffset
        dragging = true
        parent?.requestDisallowInterceptTouchEvent(true)
    }

    private fun finishDrag() {
        dragging = false
        if (-dragOffset >= acceptThreshold) {
            accepted = true
            animateDragTo(-maxDrag) { performClick() }
        } else {
            springBack()
        }
    }

    private fun springBack() {
        dragging = false
        animateDragTo(0f) {
            bounceOffset = 0f
            bounce.resume()
        }
    }

    private fun animateDragTo(target: Float, onEnd: () -> Unit) {
        release?.cancel()
        release = ValueAnimator.ofFloat(dragOffset, target).apply {
            duration = if (target == 0f) 320 else 140
            interpolator = if (target == 0f) OvershootInterpolator(2f) else DecelerateInterpolator()
            addUpdateListener {
                dragOffset = it.animatedValue as Float
                invalidate()
            }
            addListener(object : android.animation.AnimatorListenerAdapter() {
                override fun onAnimationEnd(animation: android.animation.Animator) {
                    onEnd()
                }
            })
            start()
        }
    }

    override fun onDraw(canvas: Canvas) {
        val save = canvas.save()
        canvas.translate(0f, bounceOffset + dragOffset)
        val centerY = (paddingTop + height - paddingBottom) / 2f
        canvas.drawCircle(width / 2f, centerY, radius, circlePaint)
        super.onDraw(canvas)
        canvas.restoreToCount(save)
    }
}
