package com.elumi.fakecalling.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.Toast
import com.elumi.fakecalling.MainActivity
import com.elumi.fakecalling.R

class QuickCallWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, manager: AppWidgetManager, widgetIds: IntArray) {
        val views = views(context)
        widgetIds.forEach { manager.updateAppWidget(it, views) }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action != ACTION_CALL) return
        val delay = intent.getIntExtra(EXTRA_DELAY, 0)
        val labelRes = BUTTONS.firstOrNull { it.second == delay }?.third ?: return
        val message = if (WidgetCall.schedule(context, delay)) {
            context.getString(R.string.fwc_widget_scheduled, context.getString(labelRes))
        } else {
            context.getString(R.string.fwc_widget_setup_first)
        }
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
    }

    private fun views(context: Context) =
        RemoteViews(context.packageName, R.layout.fwc_widget_quick_call).apply {
            setOnClickPendingIntent(R.id.fwc_widget_root, openApp(context))
            BUTTONS.forEach { (viewId, delay) ->
                setOnClickPendingIntent(viewId, scheduleCall(context, delay))
            }
        }

    private fun openApp(context: Context): PendingIntent =
        PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

    private fun scheduleCall(context: Context, delay: Int): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            delay,
            Intent(context, QuickCallWidget::class.java)
                .setAction(ACTION_CALL)
                .putExtra(EXTRA_DELAY, delay),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

    private companion object {
        const val ACTION_CALL = "com.elumi.fakecalling.WIDGET_CALL"
        const val EXTRA_DELAY = "delay_seconds"
        val BUTTONS = listOf(
            Triple(R.id.fwc_widget_10s, 10, R.string.fwc_widget_10s),
            Triple(R.id.fwc_widget_1m, 60, R.string.fwc_widget_1m),
            Triple(R.id.fwc_widget_5m, 300, R.string.fwc_widget_5m),
        )
    }
}
