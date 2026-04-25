package com.youssefjaber.yj_converter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.work.*
import android.content.Context

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.youssefjaber.yj_converter/converter"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "convertVideo" -> {
                    val inputPath = call.argument<String>("inputPath")
                        ?: return@setMethodCallHandler result.error(
                            "INVALID_ARG", "inputPath is null", null)
                    val outputPath = call.argument<String>("outputPath")
                        ?: return@setMethodCallHandler result.error(
                            "INVALID_ARG", "outputPath is null", null)
                    val outputName = call.argument<String>("outputName") ?: "output"

                    enqueueConversionWork(inputPath, outputPath, outputName)
                    result.success("QUEUED")
                }

                "cancelAll" -> {
                    WorkManager.getInstance(applicationContext).cancelAllWork()
                    result.success("CANCELLED")
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun enqueueConversionWork(
        inputPath: String,
        outputPath: String,
        outputName: String
    ) {
        val data = workDataOf(
            ConversionWorker.KEY_INPUT_PATH  to inputPath,
            ConversionWorker.KEY_OUTPUT_PATH to outputPath,
            ConversionWorker.KEY_OUTPUT_NAME to outputName
        )

        val request = OneTimeWorkRequestBuilder<ConversionWorker>()
            .setInputData(data)
            .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
            .addTag(ConversionWorker.TAG)
            .build()

        WorkManager.getInstance(applicationContext)
            .enqueueUniqueWork(
                ConversionWorker.UNIQUE_WORK_NAME,
                ExistingWorkPolicy.REPLACE,
                request
            )
    }
}
