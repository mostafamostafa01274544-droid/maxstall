package com.youssefjaber.yj_converter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.work.*
import androidx.media3.transformer.*
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.suspendCancellableCoroutine
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class ConversionWorker(
    context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    companion object {
        const val KEY_INPUT_PATH  = "inputPath"
        const val KEY_OUTPUT_PATH = "outputPath"
        const val KEY_OUTPUT_NAME = "outputName"
        const val TAG             = "conversion_worker"
        const val UNIQUE_WORK_NAME = "yj_video_conversion"
        const val KEY_RESULT_PATH = "resultPath"
        const val KEY_ERROR       = "error"
        private const val NOTIF_CHANNEL_ID = "yj_conversion_channel"
        private const val NOTIF_ID         = 42
    }

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val inputPath  = inputData.getString(KEY_INPUT_PATH)  ?: return@withContext Result.failure()
        val outputPath = inputData.getString(KEY_OUTPUT_PATH) ?: return@withContext Result.failure()
        val outputName = inputData.getString(KEY_OUTPUT_NAME) ?: "output"

        setForeground(buildForegroundInfo("Converting: $outputName"))

        return@withContext try {
            runMedia3Conversion(inputPath, outputPath)
            Result.success(
                workDataOf(KEY_RESULT_PATH to outputPath)
            )
        } catch (e: Exception) {
            Result.failure(
                workDataOf(KEY_ERROR to (e.message ?: "Unknown error"))
            )
        }
    }

    private suspend fun runMedia3Conversion(
        inputPath: String,
        outputPath: String
    ) = suspendCancellableCoroutine { cont ->
        // Ensure output directory exists
        File(outputPath).parentFile?.mkdirs()

        val editedItem = EditedMediaItem.Builder(
            MediaItem.fromUri("file://$inputPath")
        ).build()

        val transformer = Transformer.Builder(applicationContext)
            .addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, result: ExportResult) {
                    cont.resume(Unit)
                }
                override fun onError(
                    composition: Composition,
                    result: ExportResult,
                    exception: ExportException
                ) {
                    cont.resumeWithException(exception)
                }
            })
            .build()

        cont.invokeOnCancellation { transformer.cancel() }
        transformer.start(editedItem, outputPath)
    }

    override suspend fun getForegroundInfo(): ForegroundInfo =
        buildForegroundInfo("YJ Converter processing…")

    private fun buildForegroundInfo(text: String): ForegroundInfo {
        createNotificationChannel()

        val notification = NotificationCompat.Builder(applicationContext, NOTIF_CHANNEL_ID)
            .setContentTitle("YJ Converter")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

        return ForegroundInfo(
            NOTIF_ID,
            notification,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
                android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
            else 0
        )
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIF_CHANNEL_ID,
                "Video Conversion",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows progress while converting videos"
            }
            val nm = applicationContext.getSystemService(NotificationManager::class.java)
            nm.createNotificationChannel(channel)
        }
    }
}
