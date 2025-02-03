package bz.sgx.pavr.app

import io.flutter.BuildConfig
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.version.channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up the MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppVersion") {
                try {
                    // Retrieve version name from BuildConfig
                    val versionName = "3.1"
                    result.success(versionName)
                } catch (e: Exception) {
                    // Handle any exception and return an error
                    result.error("UNAVAILABLE", "App version not available.", e.message)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
