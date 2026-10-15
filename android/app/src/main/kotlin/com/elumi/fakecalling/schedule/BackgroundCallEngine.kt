package com.elumi.fakecalling.schedule

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.elumi.fakecalling.bridge.NativeChannels
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

object BackgroundCallEngine {
    private const val ENTRYPOINT = "scheduledCallMain"
    private const val MAX_LIFETIME_MS = 30 * 60 * 1000L

    private val handler = Handler(Looper.getMainLooper())
    private val expire = Runnable { release() }
    private var engine: FlutterEngine? = null
    private var starting = false

    fun start(context: Context) {
        if (engine != null || starting) return
        starting = true
        val appContext = context.applicationContext
        val loader = FlutterInjector.instance().flutterLoader()
        loader.startInitialization(appContext)
        loader.ensureInitializationCompleteAsync(appContext, null, handler) {
            starting = false
            val created = FlutterEngine(appContext)
            CallDispatcher.backgroundChannel =
                NativeChannels.attach(created, appContext, onRelease = ::release)
            created.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(loader.findAppBundlePath(), ENTRYPOINT),
            )
            engine = created
            handler.postDelayed(expire, MAX_LIFETIME_MS)
        }
    }

    fun release() {
        handler.removeCallbacks(expire)
        CallDispatcher.backgroundChannel = null
        engine?.destroy()
        engine = null
    }
}
