package com.youssefjaber.yj_converter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.work.*
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.youssefjaber.yj_converter/converter"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

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

                "resolveContentUri" -> {
                    val contentUriString = call.argument<String>("contentUri")
                        ?: return@setMethodCallHandler result.error(
                            "INVALID_ARG", "contentUri is null", null)
                    val filePath = getPathFromUri(contentUriString, applicationContext)
                    result.success(filePath)
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

    private fun getPathFromUri(contentUriString: String, context: Context): String? {
        val contentUri = Uri.parse(contentUriString)
        if (contentUri.scheme == "file") {
            return contentUri.path // Already a file path
        }

        val projection = arrayOf(MediaStore.Video.Media.DATA)
        var filePath: String? = null

        context.contentResolver.query(contentUri, projection, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                val columnIndex = cursor.getColumnIndex(MediaStore.Video.Media.DATA)
                if (columnIndex != -1) {
                    filePath = cursor.getString(columnIndex)
                }
            }
        }
        return filePath
    }
}