package com.elumi.fakecalling.incoming

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.util.AttributeSet
import android.view.View
import android.view.animation.LinearInterpolator
import kotlin.math.PI
import kotlin.math.sin

class SwipeHintChevrons @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : View(context, attrs) {

    private val density = resources.displayMetrics.density
    private val chevronWidth = 22f * density
    private val chevronHeight = 8f * density
    private val spacing = 11f * density
    private val path = Path()
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.WHITE
        style = Paint.Style.STROKE
        strokeWidth = 2.6f * density
        strokeCap = Paint.Cap.ROUND
        strokeJoin = Paint.Join.ROUND
    }
    private var progress = 0f
    private val shimmer = ValueAnimator.ofFloat(0f, 1f).apply {
        duration = 1400
        repeatCount = ValueAnimator.INFINITE
        interpolator = LinearInterpolator()
        addUpdateListener {
            progress = it.animatedValue as Float
            invalidate()
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val width = (chevronWidth + paint.strokeWidth * 2).toInt()
        val height = (spacing * (COUNT - 1) + chevronHeight + paint.strokeWidth * 2).toInt()
        setMeasuredDimension(
            resolveSize(width, widthMeasureSpec),
            resolveSize(height, heightMeasureSpec),
        )
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        shimmer.start()
    }

    override fun onDetachedFromWindow() {
        shimmer.cancel()
        super.onDetachedFromWindow()
    }

    override fun onDraw(canvas: Canvas) {
        val centerX = width / 2f
        val bottomTip = height - paint.strokeWidth - chevronHeight
        for (index in 0 until COUNT) {
            val tipY = bottomTip - index * spacing
            paint.alpha = (255 * brightness(index)).toInt()
            path.reset()
            path.moveTo(centerX - chevronWidth / 2f, tipY + chevronHeight)
            path.lineTo(centerX, tipY)
            path.lineTo(centerX + chevronWidth / 2f, tipY + chevronHeight)
            canvas.drawPath(path, paint)
        }
    }

    private fun brightness(index: Int): Float {
        val local = ((progress - index * STEP_DELAY) % 1f + 1f) % 1f
        val glow = if (local < GLOW_WINDOW) sin(PI * local / GLOW_WINDOW).toFloat() else 0f
        return MIN_ALPHA + (1f - MIN_ALPHA) * glow
    }

    private companion object {
        const val COUNT = 3
        const val STEP_DELAY = 0.16f
        const val GLOW_WINDOW = 0.4f
        const val MIN_ALPHA = 0.18f
    }
}
