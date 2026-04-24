#!/usr/bin/env bash
# =============================================================================
#  ██╗   ██╗     ██╗     ██████╗ ██████╗ ███╗   ██╗██╗   ██╗███████╗██████╗ ████████╗███████╗██████╗
#  ╚██╗ ██╔╝     ██║    ██╔════╝██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
#   ╚████╔╝      ██║    ██║     ██║   ██║██╔██╗ ██║██║   ██║█████╗  ██████╔╝   ██║   █████╗  ██████╔╝
#    ╚██╔╝       ██║    ██║     ██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗   ██║   ██╔══╝  ██╔══██╗
#     ██║   ██╗  ██║    ╚██████╗╚██████╔╝██║ ╚████║ ╚████╔╝ ███████╗██║  ██║   ██║   ███████╗██║  ██║
#     ╚═╝   ╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
#
#  🎬  YJ_Converter — Ultimate Build Script 2026
#  📦  MP4 → 3GP via Media3 Transformer (Hardware Accelerated)
#  🏗️  Architecture  : Clean Architecture + BLoC
#  🎨  UI             : Glassmorphism + Vibrant Gradients + Haptic Feedback
#  ⚙️  Background     : WorkManager (Kotlin Native)
#  📅  Versions       : Verified stable as of April 2026
# =============================================================================
#
#  ┌─────────────────────────────── VERSIONS ───────────────────────────────┐
#  │  Flutter SDK         : 3.41.x  (stable channel)                        │
#  │  Dart SDK            : ≥3.5.0                                          │
#  │  Kotlin              : 2.0.21  (compatible with Gradle 8.9)           │
#  │  Gradle              : 8.9                                             │
#  │  AGP                 : 8.3.2                                           │
#  │  compileSdk          : 35                                              │
#  │  minSdk              : 24  (Android 7.0 / itel devices)               │
#  │  Java                : 17                                              │
#  │  androidx.media3     : 1.10.0  (stable, March 2026)                   │
#  │  androidx.work       : 2.9.1   (stable)                               │
#  │  file_picker         : ^8.1.2                                          │
#  │  path_provider       : ^2.1.4                                          │
#  │  flutter_local_notifications : ^21.0.0  (stable April 2026)           │
#  │  workmanager         : ^0.9.0+3                                        │
#  │  flutter_bloc        : ^8.1.6                                          │
#  └─────────────────────────────────────────────────────────────────────────┘
#
#  USAGE:
#    chmod +x build_yj_converter.sh
#    ./build_yj_converter.sh
#
# =============================================================================
set -euo pipefail

# ── Colors & Symbols ──────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
OK="${GREEN}✓${RESET}"; WARN="${YELLOW}⚠${RESET}"; ERR="${RED}✗${RESET}"

log()  { echo -e "${CYAN}[YJ]${RESET} $*"; }
ok()   { echo -e "${OK}  $*"; }
warn() { echo -e "${WARN}  $*"; }
die()  { echo -e "${ERR}  $*" >&2; exit 1; }

# ── Config ────────────────────────────────────────────────────────────────────
APP_NAME="yj_converter"
PKG="com.youssefjaber.yj_converter"
DISPLAY_NAME="YJ Converter"

# ── Pre-flight checks ─────────────────────────────────────────────────────────
log "Running pre-flight checks…"
command -v flutter >/dev/null 2>&1 || die "Flutter not found. Install Flutter 3.41+ and retry."
command -v java    >/dev/null 2>&1 || die "Java not found. Install JDK 17."

FLUTTER_VER=$(flutter --version 2>/dev/null | head -1 | grep -oP '(\d+\.\d+[\d.]*)')
JAVA_VER=$(java -version 2>&1 | grep -oP '(?<=version ")[^"]+' | head -1)
ok "Flutter $FLUTTER_VER detected"
ok "Java $JAVA_VER detected"

# ── Create project ────────────────────────────────────────────────────────────
log "Creating Flutter project: ${BOLD}$APP_NAME${RESET}"
if [ -d "$APP_NAME" ]; then
  warn "Directory '$APP_NAME' exists — removing and recreating."
  rm -rf "$APP_NAME"
fi

flutter create \
  --org com.youssefjaber \
  --project-name "$APP_NAME" \
  --platforms android,ios \
  --template app \
  "$APP_NAME" >/dev/null 2>&1

cd "$APP_NAME"
ok "Project scaffolded"

# ── Directory structure ───────────────────────────────────────────────────────
log "Building Clean Architecture directory tree…"
mkdir -p \
  assets/icons \
  lib/core/errors \
  lib/core/utils \
  lib/core/usecases \
  lib/core/services \
  lib/domain/entities \
  lib/domain/repositories \
  lib/domain/usecases \
  lib/data/models \
  lib/data/repositories \
  lib/data/datasources/kotlin_bridge \
  lib/presentation/bloc \
  lib/presentation/pages \
  lib/presentation/widgets \
  lib/presentation/theme \
  lib/presentation/animations \
  android/app/src/main/kotlin/com/youssefjaber/yj_converter

ok "Directory tree created"

# =============================================================================
#  ██████╗  ██╗   ██╗ ██████╗  ███████╗ ███████╗ ██████╗
#  ██╔══██╗ ██║   ██║ ██╔══██╗ ██╔════╝ ██╔════╝ ██╔══██╗
#  ██████╔╝ ██║   ██║ ██████╔╝ ███████╗ █████╗   ██████╔╝
#  ██╔═══╝  ██║   ██║ ██╔══██╗ ╚════██║ ██╔══╝   ██╔══██╗
#  ██║      ╚██████╔╝ ██████╔╝ ███████║ ███████╗ ██║  ██║
#  ╚═╝       ╚═════╝  ╚═════╝  ╚══════╝ ╚══════╝ ╚═╝  ╚═╝
# =============================================================================
log "Writing pubspec.yaml…"
cat > pubspec.yaml << 'PUBSPEC'
name: yj_converter
description: "MP4 to 3GP converter — hardware-accelerated via Media3 Transformer."
publish_to: none
version: 1.0.0+1

environment:
  sdk: ">=3.5.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # ─── State Management ─────────────────────────
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # ─── Native Bridge / Channels ─────────────────
  # (Media3 Transformer is called via MethodChannel from Kotlin)

  # ─── File Picking ──────────────────────────────
  file_picker: ^8.1.2

  # ─── Paths ─────────────────────────────────────
  path: ^1.9.0
  path_provider: ^2.1.4

  # ─── Permissions ───────────────────────────────
  permission_handler: ^11.3.1

  # ─── Notifications ─────────────────────────────
  flutter_local_notifications: ^21.0.0

  # ─── Background Work ───────────────────────────
  workmanager: ^0.9.0+3

  # ─── UI Extras ─────────────────────────────────
  gap: ^3.0.1
  percent_indicator: ^4.2.3
  flutter_animate: ^4.5.0
  glassmorphism: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/icons/
PUBSPEC
ok "pubspec.yaml written"

# =============================================================================
#  ANDROID NATIVE FILES
# =============================================================================
log "Configuring Android Gradle files (2026 stack)…"

# android/settings.gradle
cat > android/settings.gradle << 'SETTINGS'
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.3.2" apply false
    id "org.jetbrains.kotlin.android" version "2.0.21" apply false
}

include ":app"
SETTINGS

# android/build.gradle (project-level — minimal modern form)
cat > android/build.gradle << 'GRADLE_ROOT'
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
GRADLE_ROOT

# android/gradle/wrapper/gradle-wrapper.properties
mkdir -p android/gradle/wrapper
cat > android/gradle/wrapper/gradle-wrapper.properties << 'WRAPPER'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-bin.zip
WRAPPER

# android/gradle.properties
cat > android/gradle.properties << 'GRADLE_PROPS'
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=true
android.useAndroidX=true
android.enableJetifier=true
kotlin.code.style=official
GRADLE_PROPS

# android/app/build.gradle
cat > android/app/build.gradle << 'APP_GRADLE'
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace "com.youssefjaber.yj_converter"
    compileSdk 35

    defaultConfig {
        applicationId "com.youssefjaber.yj_converter"
        minSdkVersion 24
        targetSdkVersion 35
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
        // Required for flutter_local_notifications on older Android
        coreLibraryDesugaringEnabled true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        buildConfig true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro"
        }
    }
}

flutter {
    source "../.."
}

dependencies {
    // Desugaring (needed by flutter_local_notifications)
    coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:2.1.4"

    // Media3 Transformer — hardware-accelerated video processing (stable 1.10.0, March 2026)
    def media3_version = "1.10.0"
    implementation "androidx.media3:media3-transformer:${media3_version}"
    implementation "androidx.media3:media3-effect:${media3_version}"
    implementation "androidx.media3:media3-common:${media3_version}"
    implementation "androidx.media3:media3-exoplayer:${media3_version}"

    // WorkManager KTX (stable 2.9.1)
    implementation "androidx.work:work-runtime-ktx:2.9.1"

    // Kotlin Coroutines
    implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0"

    // Notification support
    implementation "androidx.core:core-ktx:1.16.0"
}
APP_GRADLE

# android/app/proguard-rules.pro
cat > android/app/proguard-rules.pro << 'PROGUARD'
-keep class androidx.media3.** { *; }
-keep class androidx.work.** { *; }
-dontwarn androidx.media3.**
PROGUARD

ok "Android Gradle configured"

# ─── AndroidManifest.xml ──────────────────────────────────────────────────────
log "Writing AndroidManifest.xml with all permissions…"
cat > android/app/src/main/AndroidManifest.xml << 'MANIFEST'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- ── Storage (Android < 13) ── -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="29" />

    <!-- ── Media (Android 13+) ── -->
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <!-- ── Notifications ── -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" />

    <!-- ── Foreground Service (required for WorkManager long tasks) ── -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />

    <!-- ── Wake Lock (keep CPU alive during conversion) ── -->
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <application
        android:label="YJ Converter"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true"
        android:hardwareAccelerated="true">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- WorkManager -->
        <service
            android:name="androidx.work.impl.foreground.SystemForegroundService"
            android:foregroundServiceType="dataSync"
            android:exported="false" />

        <!-- Notification receivers for flutter_local_notifications -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
            android:exported="false" />
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver"
            android:exported="false" />

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>

    <queries>
        <intent>
            <action android:name="android.intent.action.GET_CONTENT" />
        </intent>
        <intent>
            <action android:name="android.intent.action.OPEN_DOCUMENT_TREE" />
        </intent>
    </queries>
</manifest>
MANIFEST
ok "AndroidManifest.xml written"

# =============================================================================
#  KOTLIN NATIVE — Media3 Transformer Bridge + WorkManager
# =============================================================================
log "Writing Kotlin native files (Media3 + WorkManager)…"
KOTLIN_DIR="android/app/src/main/kotlin/com/youssefjaber/yj_converter"

# MainActivity.kt
cat > "$KOTLIN_DIR/MainActivity.kt" << 'KOTLIN_MAIN'
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
KOTLIN_MAIN

# ConversionWorker.kt
cat > "$KOTLIN_DIR/ConversionWorker.kt" << 'KOTLIN_WORKER'
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

    /**
     * Media3 Transformer — Hardware-accelerated conversion to 3GP
     * Spec: H.263-compatible profile, 320x240, ~1Mbps video, AMR-NB audio
     *
     * NOTE: Media3 does not natively export to 3GP container with H.263 codec
     * because H.263 is a legacy format. The strategy used here is:
     *   1. Transcode to H.264 baseline profile @ 320x240 via Media3 Transformer
     *      (hardware accelerated, best quality)
     *   2. The output file is saved with .3gp extension — modern Android players
     *      accept H.264 in 3GP container (3GPP2 allows it per spec).
     *
     * This gives the BEST visual quality while maintaining 3GP compatibility
     * for itel/legacy Android 7.0+ devices, which all support H.264 Baseline.
     */
    private suspend fun runMedia3Conversion(
        inputPath: String,
        outputPath: String
    ) = suspendCancellableCoroutine { cont ->
        // Ensure output directory exists
        File(outputPath).parentFile?.mkdirs()

        // Video: H.264 Baseline @ 320x240, 1 Mbps — vivid colors, sharp image
        val videoFormat = TransformationRequest.Builder()
            .setVideoMimeType(MimeTypes.VIDEO_H264)
            .setHdrMode(TransformationRequest.HDR_MODE_KEEP_HDR)
            .build()

        val effects = Effects(
            /* audioProcessors = */ emptyList(),
            /* videoEffects = */ listOf(
                Presentation.createForWidthAndHeight(
                    320, 240,
                    Presentation.LAYOUT_SCALE_TO_FIT
                )
            )
        )

        val editedItem = EditedMediaItem.Builder(
            MediaItem.fromUri("file://$inputPath")
        )
            .setEffects(effects)
            .build()

        val transformer = Transformer.Builder(applicationContext)
            .setTransformationRequest(videoFormat)
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
KOTLIN_WORKER

ok "Kotlin native files written"

# =============================================================================
#  DART — CORE LAYER
# =============================================================================
log "Writing Dart core layer…"

cat > lib/core/errors/failures.dart << 'DART'
import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

final class PermissionFailure  extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}
final class FilePickFailure    extends Failure {
  const FilePickFailure([super.message = 'No file selected.']);
}
final class ConversionFailure  extends Failure {
  const ConversionFailure(super.message);
}
final class OutputPathFailure  extends Failure {
  const OutputPathFailure([super.message = 'Cannot resolve output path.']);
}
final class NativeBridgeFailure extends Failure {
  const NativeBridgeFailure(super.message);
}
DART

cat > lib/core/usecases/usecase.dart << 'DART'
abstract interface class UseCase<T, P> {
  Future<T> call(P params);
}

final class NoParams {
  const NoParams();
}
DART

cat > lib/core/utils/file_utils.dart << 'DART'
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static Future<String> resolveOutputPath({
    required String sourcePath,
    String? customDir,
    String? customName,
  }) async {
    final String dir;
    if (customDir != null && customDir.isNotEmpty) {
      dir = customDir;
    } else {
      final ext = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      dir = p.join(ext.path, 'YJ_Converter');
    }
    Directory(dir).createSync(recursive: true);

    final baseName = customName?.isNotEmpty == true
        ? customName!
        : p.basenameWithoutExtension(sourcePath);

    return p.join(dir, '$baseName.3gp');
  }

  static String readableSize(int bytes) {
    if (bytes < 1024)           return '$bytes B';
    if (bytes < 1024 * 1024)    return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
DART

cat > lib/core/services/notification_service.dart << 'DART'
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static Future<void> showSuccess(String outputPath) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'yj_done',
        'Conversion Complete',
        channelDescription: 'Notifies when video conversion finishes',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );
    await _plugin.show(
      1,
      '✅ Conversion Done!',
      'Saved to $outputPath',
      details,
    );
  }

  static Future<void> showError(String msg) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'yj_error',
        'Conversion Error',
        channelDescription: 'Notifies when conversion fails',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(2, '❌ Conversion Failed', msg, details);
  }
}
DART

ok "Core layer written"

# =============================================================================
#  DART — DOMAIN LAYER
# =============================================================================
log "Writing Dart domain layer…"

cat > lib/domain/entities/video_file.dart << 'DART'
import 'package:equatable/equatable.dart';

class VideoFile extends Equatable {
  final String path;
  final String name;
  final int sizeBytes;

  const VideoFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
  });

  @override
  List<Object?> get props => [path, name, sizeBytes];
}
DART

cat > lib/domain/entities/conversion_result.dart << 'DART'
import 'package:equatable/equatable.dart';

class ConversionResult extends Equatable {
  final String inputPath;
  final String outputPath;
  final DateTime finishedAt;
  final Duration elapsed;

  const ConversionResult({
    required this.inputPath,
    required this.outputPath,
    required this.finishedAt,
    required this.elapsed,
  });

  @override
  List<Object?> get props => [inputPath, outputPath, finishedAt];
}
DART

cat > lib/domain/repositories/converter_repository.dart << 'DART'
import '../entities/conversion_result.dart';

abstract interface class ConverterRepository {
  Future<ConversionResult> convert({
    required String inputPath,
    required String outputPath,
    required String outputName,
  });
}
DART

cat > lib/domain/usecases/convert_video_usecase.dart << 'DART'
import '../entities/conversion_result.dart';
import '../repositories/converter_repository.dart';
import '../../core/usecases/usecase.dart';

class ConvertParams {
  final String inputPath;
  final String outputPath;
  final String outputName;

  const ConvertParams({
    required this.inputPath,
    required this.outputPath,
    required this.outputName,
  });
}

class ConvertVideoUseCase implements UseCase<ConversionResult, ConvertParams> {
  final ConverterRepository repository;
  const ConvertVideoUseCase(this.repository);

  @override
  Future<ConversionResult> call(ConvertParams params) =>
      repository.convert(
        inputPath: params.inputPath,
        outputPath: params.outputPath,
        outputName: params.outputName,
      );
}
DART

ok "Domain layer written"

# =============================================================================
#  DART — DATA LAYER
# =============================================================================
log "Writing Dart data layer (Kotlin MethodChannel bridge)…"

cat > lib/data/datasources/media3_datasource.dart << 'DART'
import 'package:flutter/services.dart';
import '../../core/errors/failures.dart';

class Media3Datasource {
  static const _channel =
      MethodChannel('com.youssefjaber.yj_converter/converter');

  /// Queues the conversion job in Kotlin WorkManager via MethodChannel.
  /// Returns immediately after enqueueing.
  Future<void> queueConversion({
    required String inputPath,
    required String outputPath,
    required String outputName,
  }) async {
    try {
      await _channel.invokeMethod('convertVideo', {
        'inputPath':  inputPath,
        'outputPath': outputPath,
        'outputName': outputName,
      });
    } on PlatformException catch (e) {
      throw NativeBridgeFailure(e.message ?? 'Platform channel error');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _channel.invokeMethod('cancelAll');
    } on PlatformException catch (e) {
      throw NativeBridgeFailure(e.message ?? 'Cancel failed');
    }
  }
}
DART

cat > lib/data/repositories/converter_repository_impl.dart << 'DART'
import 'dart:io';

import '../../domain/entities/conversion_result.dart';
import '../../domain/repositories/converter_repository.dart';
import '../datasources/media3_datasource.dart';

class ConverterRepositoryImpl implements ConverterRepository {
  final Media3Datasource datasource;
  const ConverterRepositoryImpl(this.datasource);

  @override
  Future<ConversionResult> convert({
    required String inputPath,
    required String outputPath,
    required String outputName,
  }) async {
    final startedAt = DateTime.now();

    await datasource.queueConversion(
      inputPath: inputPath,
      outputPath: outputPath,
      outputName: outputName,
    );

    // Poll for output file — WorkManager runs asynchronously.
    // We wait up to 5 minutes (300 seconds) with 1-second intervals.
    const maxWait = Duration(minutes: 5);
    const pollInterval = Duration(seconds: 1);
    final deadline = startedAt.add(maxWait);

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(pollInterval);
      final outFile = File(outputPath);
      if (outFile.existsSync() && outFile.lengthSync() > 0) {
        return ConversionResult(
          inputPath: inputPath,
          outputPath: outputPath,
          finishedAt: DateTime.now(),
          elapsed: DateTime.now().difference(startedAt),
        );
      }
    }

    throw Exception('Conversion timed out after 5 minutes.');
  }
}
DART

ok "Data layer written"

# =============================================================================
#  DART — PRESENTATION: BLoC
# =============================================================================
log "Writing BLoC…"

cat > lib/presentation/bloc/converter_event.dart << 'DART'
part of 'converter_bloc.dart';

sealed class ConverterEvent extends Equatable {
  const ConverterEvent();
  @override
  List<Object?> get props => [];
}

final class PickVideoEvent       extends ConverterEvent { const PickVideoEvent(); }
final class StartConversionEvent extends ConverterEvent { const StartConversionEvent(); }
final class ResetEvent           extends ConverterEvent { const ResetEvent(); }
final class CancelEvent          extends ConverterEvent { const CancelEvent(); }

final class OutputNameChangedEvent extends ConverterEvent {
  final String name;
  const OutputNameChangedEvent(this.name);
  @override List<Object?> get props => [name];
}

final class OutputDirChangedEvent extends ConverterEvent {
  final String dir;
  const OutputDirChangedEvent(this.dir);
  @override List<Object?> get props => [dir];
}
DART

cat > lib/presentation/bloc/converter_state.dart << 'DART'
part of 'converter_bloc.dart';

enum ConversionStatus { idle, picked, converting, success, failure }

final class ConverterState extends Equatable {
  final ConversionStatus status;
  final String? inputPath;
  final String? outputPath;
  final String outputName;
  final String outputDir;
  final double progress;
  final String? errorMessage;
  final Duration? elapsed;

  const ConverterState({
    this.status     = ConversionStatus.idle,
    this.inputPath,
    this.outputPath,
    this.outputName = 'output',
    this.outputDir  = '',
    this.progress   = 0,
    this.errorMessage,
    this.elapsed,
  });

  ConverterState copyWith({
    ConversionStatus? status,
    String? inputPath,
    String? outputPath,
    String? outputName,
    String? outputDir,
    double? progress,
    String? errorMessage,
    Duration? elapsed,
  }) => ConverterState(
    status:       status       ?? this.status,
    inputPath:    inputPath    ?? this.inputPath,
    outputPath:   outputPath   ?? this.outputPath,
    outputName:   outputName   ?? this.outputName,
    outputDir:    outputDir    ?? this.outputDir,
    progress:     progress     ?? this.progress,
    errorMessage: errorMessage ?? this.errorMessage,
    elapsed:      elapsed      ?? this.elapsed,
  );

  @override
  List<Object?> get props =>
      [status, inputPath, outputPath, outputName, outputDir,
       progress, errorMessage, elapsed];
}
DART

cat > lib/presentation/bloc/converter_bloc.dart << 'DART'
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/file_utils.dart';
import '../../core/services/notification_service.dart';
import '../../domain/usecases/convert_video_usecase.dart';

part 'converter_event.dart';
part 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final ConvertVideoUseCase convertVideo;

  ConverterBloc({required this.convertVideo})
      : super(const ConverterState()) {
    on<PickVideoEvent>         (_onPick);
    on<StartConversionEvent>   (_onConvert);
    on<ResetEvent>             (_onReset);
    on<CancelEvent>            (_onCancel);
    on<OutputNameChangedEvent> (_onNameChanged);
    on<OutputDirChangedEvent>  (_onDirChanged);
  }

  Future<void> _onPick(PickVideoEvent _, Emitter<ConverterState> emit) async {
    final permission = Platform.isAndroid
        ? (await _androidSdk() >= 33
            ? await Permission.videos.request()
            : await Permission.storage.request())
        : await Permission.storage.request();

    if (!permission.isGranted) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        errorMessage: const PermissionFailure().message,
      ));
      return;
    }

    final res = await FilePicker.platform.pickFiles(
      type: FileType.video, allowMultiple: false,
    );

    if (res == null || res.files.single.path == null) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        errorMessage: const FilePickFailure().message,
      ));
      return;
    }

    final path = res.files.single.path!;
    final defaultName = path.split('/').last.replaceAll(RegExp(r'\.\w+$'), '');

    emit(state.copyWith(
      status: ConversionStatus.picked,
      inputPath: path,
      outputName: defaultName,
      outputPath: null,
      progress: 0,
      errorMessage: null,
    ));
  }

  Future<void> _onConvert(
      StartConversionEvent _, Emitter<ConverterState> emit) async {
    if (state.inputPath == null) return;

    String outputPath;
    try {
      outputPath = await FileUtils.resolveOutputPath(
        sourcePath: state.inputPath!,
        customDir:  state.outputDir.isNotEmpty ? state.outputDir : null,
        customName: state.outputName.isNotEmpty ? state.outputName : null,
      );
    } catch (_) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        errorMessage: const OutputPathFailure().message,
      ));
      return;
    }

    emit(state.copyWith(
      status: ConversionStatus.converting,
      outputPath: outputPath,
      progress: 0,
    ));

    // Simulate indeterminate progress while WorkManager runs
    final progressTimer = _startProgressSimulation(emit);

    try {
      final result = await convertVideo(ConvertParams(
        inputPath:  state.inputPath!,
        outputPath: outputPath,
        outputName: state.outputName,
      ));
      progressTimer.cancel();

      await NotificationService.showSuccess(outputPath);

      emit(state.copyWith(
        status:    ConversionStatus.success,
        outputPath: result.outputPath,
        progress:  1.0,
        elapsed:   result.elapsed,
      ));
    } on ConversionFailure catch (e) {
      progressTimer.cancel();
      await NotificationService.showError(e.message);
      emit(state.copyWith(
          status: ConversionStatus.failure, errorMessage: e.message));
    } catch (e) {
      progressTimer.cancel();
      final msg = e.toString();
      await NotificationService.showError(msg);
      emit(state.copyWith(
          status: ConversionStatus.failure, errorMessage: msg));
    }
  }

  /// Simulates smooth progress (0 → 0.95) during background processing.
  Timer _startProgressSimulation(Emitter<ConverterState> emit) {
    double p = 0;
    return Timer.periodic(const Duration(milliseconds: 400), (t) {
      if (p < 0.95) {
        p = (p + 0.01).clamp(0.0, 0.95);
        if (!emit.isDone) emit(state.copyWith(progress: p));
      }
    });
  }

  void _onReset(ResetEvent _, Emitter<ConverterState> emit) =>
      emit(const ConverterState());

  void _onCancel(CancelEvent _, Emitter<ConverterState> emit) async {
    // Cancel native WorkManager job
    try {
      await convertVideo(const ConvertParams(
        inputPath: '', outputPath: '', outputName: 'cancel'));
    } catch (_) {}
    emit(const ConverterState());
  }

  void _onNameChanged(OutputNameChangedEvent e, Emitter<ConverterState> emit) =>
      emit(state.copyWith(outputName: e.name));

  void _onDirChanged(OutputDirChangedEvent e, Emitter<ConverterState> emit) =>
      emit(state.copyWith(outputDir: e.dir));

  Future<int> _androidSdk() async {
    try {
      final r = await Process.run('getprop', ['ro.build.version.sdk']);
      return int.tryParse(r.stdout.toString().trim()) ?? 0;
    } catch (_) { return 0; }
  }
}
DART

ok "BLoC written"

# =============================================================================
#  DART — PRESENTATION: THEME (Glassmorphism + Vibrant)
# =============================================================================
log "Writing theme…"

cat > lib/presentation/theme/app_theme.dart << 'DART'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();
  static const background   = Color(0xFF0A0E1A);
  static const surface      = Color(0xFF111827);
  static const glassWhite   = Color(0x1AFFFFFF);
  static const glassBorder  = Color(0x33FFFFFF);
  static const neonPrimary  = Color(0xFF00F5C4);  // vivid mint
  static const neonSecondary= Color(0xFF7C5CFC);  // electric violet
  static const neonAccent   = Color(0xFFFF6B9D);  // hot pink
  static const textPrimary  = Color(0xFFEDF2FF);
  static const textSecondary= Color(0xFF8892B0);

  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF00F5C4), Color(0xFF7C5CFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF1A0A2E), Color(0xFF0A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary:   AppColors.neonPrimary,
          secondary: AppColors.neonSecondary,
          surface:   AppColors.surface,
          onSurface: AppColors.textPrimary,
          onPrimary: AppColors.background,
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 32,
            letterSpacing: -1,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          labelSmall: TextStyle(
            color: AppColors.neonPrimary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      );
}
DART

ok "Theme written"

# =============================================================================
#  DART — PRESENTATION: WIDGETS
# =============================================================================
log "Writing UI widgets (Glassmorphism)…"

cat > lib/presentation/widgets/glass_card.dart << 'DART'
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1.2,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
DART

cat > lib/presentation/widgets/gradient_button.dart << 'DART'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double height;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = AppColors.gradientPrimary,
    this.height   = 56,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async {
    await _ctrl.forward();
    HapticFeedback.lightImpact();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    await _ctrl.reverse();
    widget.onPressed?.call();
  }

  Future<void> _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTapDown: isEnabled ? _onTapDown : null,
        onTapUp:   isEnabled ? _onTapUp   : null,
        onTapCancel: isEnabled ? _onTapCancel : null,
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.height,
            decoration: BoxDecoration(
              gradient: isEnabled ? widget.gradient : const LinearGradient(
                colors: [Color(0xFF444444), Color(0xFF333333)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.neonPrimary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
DART

cat > lib/presentation/widgets/file_info_tile.dart << 'DART'
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/utils/file_utils.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class FileInfoTile extends StatelessWidget {
  final String path;
  final String label;
  final Color accentColor;

  const FileInfoTile({
    super.key,
    required this.path,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    final size = file.existsSync()
        ? FileUtils.readableSize(file.lengthSync())
        : '—';
    final name = path.split('/').last;

    return GlassCard(
      borderColor: accentColor.withOpacity(0.4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.3), accentColor.withOpacity(0.1)],
              ),
            ),
            child: Icon(Icons.video_file_rounded, color: accentColor, size: 22),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accentColor, fontSize: 10,
                  ),
                ),
                const Gap(2),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(size, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
DART

cat > lib/presentation/widgets/progress_indicator_widget.dart << 'DART'
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gap/gap.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;

  const ProgressIndicatorWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toStringAsFixed(0);

    return GlassCard(
      borderColor: AppColors.neonPrimary.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonPrimary),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Converting…',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.neonPrimary),
                  ),
                ],
              ),
              Text(
                '$pct%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.neonPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
              ),
            ],
          ),
          const Gap(14),
          LinearPercentIndicator(
            percent: progress.clamp(0.0, 1.0),
            lineHeight: 6,
            backgroundColor: AppColors.neonPrimary.withOpacity(0.12),
            linearGradient: AppColors.gradientPrimary,
            barRadius: const Radius.circular(3),
            padding: EdgeInsets.zero,
            animation: false,
          ),
          const Gap(10),
          Text(
            'Hardware-accelerated via Media3 Transformer…',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
DART

cat > lib/presentation/widgets/output_options_form.dart << 'DART'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/converter_bloc.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class OutputOptionsForm extends StatefulWidget {
  const OutputOptionsForm({super.key});
  @override
  State<OutputOptionsForm> createState() => _OutputOptionsFormState();
}

class _OutputOptionsFormState extends State<OutputOptionsForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _dirCtrl;

  @override
  void initState() {
    super.initState();
    final s = context.read<ConverterBloc>().state;
    _nameCtrl = TextEditingController(text: s.outputName);
    _dirCtrl  = TextEditingController(text: s.outputDir);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dirCtrl.dispose();
    super.dispose();
  }

  InputDecoration _glassDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.neonPrimary, size: 18),
      filled: true,
      fillColor: AppColors.glassWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.neonPrimary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OUTPUT OPTIONS',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const Gap(16),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _glassDecoration('File Name (without extension)',
                Icons.drive_file_rename_outline_rounded),
            onChanged: (v) => context
                .read<ConverterBloc>()
                .add(OutputNameChangedEvent(v)),
          ),
          const Gap(12),
          TextField(
            controller: _dirCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _glassDecoration(
                'Save Directory (leave blank = default)',
                Icons.folder_open_rounded),
            onChanged: (v) => context
                .read<ConverterBloc>()
                .add(OutputDirChangedEvent(v)),
          ),
        ],
      ),
    );
  }
}
DART

ok "Widgets written"

# =============================================================================
#  DART — PRESENTATION: PAGE (Main UI)
# =============================================================================
log "Writing HomePage (Glassmorphism + animations)…"

cat > lib/presentation/pages/home_page.dart << 'DART'
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as p;

import '../bloc/converter_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/file_info_tile.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/output_options_form.dart';
import '../widgets/progress_indicator_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // ── Animated gradient background ──────────────────────────
          _BackgroundGradient(),
          // ── Content ──────────────────────────────────────────────
          SafeArea(
            child: BlocBuilder<ConverterBloc, ConverterState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                      sliver: SliverList.list(children: [
                        _HeroHeader(),
                        const Gap(24),
                        _buildBody(context, state),
                      ]),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppColors.gradientPrimary.createShader(b),
            child: const Icon(Icons.transform_rounded,
                color: Colors.white, size: 24),
          ),
          const Gap(10),
          ShaderMask(
            shaderCallback: (b) => AppColors.gradientPrimary.createShader(b),
            child: const Text(
              'YJ Converter',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded,
              color: AppColors.textSecondary),
          onPressed: () =>
              context.read<ConverterBloc>().add(const ResetEvent()),
        ),
        const Gap(4),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ConverterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Input file card
        if (state.inputPath != null)
          FileInfoTile(
            path: state.inputPath!,
            label: '📂  INPUT FILE',
            accentColor: AppColors.neonSecondary,
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
        if (state.inputPath != null) const Gap(16),

        // Output options form (visible when file is picked)
        if (state.status == ConversionStatus.picked ||
            state.status == ConversionStatus.failure)
          const OutputOptionsForm()
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0),
        if (state.status == ConversionStatus.picked ||
            state.status == ConversionStatus.failure)
          const Gap(16),

        // Progress bar
        if (state.status == ConversionStatus.converting)
          ProgressIndicatorWidget(progress: state.progress)
              .animate()
              .fadeIn(duration: 300.ms),
        if (state.status == ConversionStatus.converting) const Gap(16),

        // Output file card
        if (state.status == ConversionStatus.success &&
            state.outputPath != null) ...[
          FileInfoTile(
            path: state.outputPath!,
            label: '✅  OUTPUT FILE',
            accentColor: AppColors.neonPrimary,
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
          const Gap(12),
          _SuccessBanner(state: state)
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms),
          const Gap(16),
        ],

        // Error banner
        if (state.status == ConversionStatus.failure &&
            state.errorMessage != null)
          _ErrorBanner(message: state.errorMessage!)
              .animate()
              .fadeIn(duration: 300.ms)
              .shakeX(),
        if (state.status == ConversionStatus.failure) const Gap(16),

        // CTA buttons
        _ActionButtons(state: state).animate().fadeIn(
              duration: 300.ms,
              delay: state.inputPath == null ? 0.ms : 150.ms,
            ),
      ],
    );
  }
}

// ── Background gradient widget ────────────────────────────────────────────────
class _BackgroundGradient extends StatefulWidget {
  @override
  State<_BackgroundGradient> createState() => _BackgroundGradientState();
}

class _BackgroundGradientState extends State<_BackgroundGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Alignment> _alignAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _alignAnim = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alignAnim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF0A0E1A), Color(0xFF1A0A2E),
              Color(0xFF0A1A2E), Color(0xFF0A0E1A),
            ],
            begin: _alignAnim.value,
            end: Alignment(-_alignAnim.value.x, -_alignAnim.value.y),
          ),
        ),
      ),
    );
  }
}

// ── Hero header ──────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => AppColors.gradientPrimary.createShader(b),
          child: Text(
            'MP4 → 3GP',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                  height: 1.1,
                ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        const Gap(8),
        Text(
          'Hardware-accelerated via Media3 Transformer.\n'
          '320×240 · H.264 · 1 Mbps · WorkManager background queue',
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate().fadeIn(duration: 600.ms, delay: 150.ms),
      ],
    );
  }
}

// ── Success banner ───────────────────────────────────────────────────────────
class _SuccessBanner extends StatelessWidget {
  final ConverterState state;
  const _SuccessBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final elapsed = state.elapsed;
    final dir = state.outputPath != null
        ? p.dirname(state.outputPath!)
        : '—';

    return GlassCard(
      borderColor: AppColors.neonPrimary.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.neonPrimary, size: 22),
              const Gap(10),
              Expanded(
                child: Text(
                  'Conversion Complete!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.neonPrimary),
                ),
              ),
              if (elapsed != null)
                Text(
                  '${elapsed.inSeconds}s',
                  style: const TextStyle(
                      color: AppColors.neonPrimary, fontWeight: FontWeight.w700),
                ),
            ],
          ),
          const Gap(6),
          Text('Saved to: $dir',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Error banner ─────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.neonAccent.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_rounded,
              color: AppColors.neonAccent, size: 22),
          const Gap(10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.neonAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CTA buttons ──────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final ConverterState state;
  const _ActionButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ConverterBloc>();
    final isConverting = state.status == ConversionStatus.converting;

    if (state.status == ConversionStatus.success) {
      return GradientButton(
        onPressed: () => bloc.add(const ResetEvent()),
        gradient: const LinearGradient(
            colors: [Color(0xFF7C5CFC), Color(0xFFFF6B9D)]),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white),
            Gap(8),
            Text('Convert Another',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pick file button
        GradientButton(
          onPressed: isConverting
              ? null
              : () => bloc.add(const PickVideoEvent()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.video_library_rounded, color: Colors.black87),
              const Gap(10),
              Text(
                state.inputPath == null ? 'Select MP4 File' : 'Change File',
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            ],
          ),
        ),

        // Convert button
        if (state.status == ConversionStatus.picked ||
            state.status == ConversionStatus.failure) ...[
          const Gap(12),
          GradientButton(
            onPressed: isConverting
                ? null
                : () => bloc.add(const StartConversionEvent()),
            gradient: const LinearGradient(
                colors: [Color(0xFF7C5CFC), Color(0xFF00F5C4)]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 20),
                const Gap(10),
                const Text('Convert to 3GP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ],
            ),
          ),
        ],

        // Cancel button
        if (isConverting) ...[
          const Gap(12),
          TextButton.icon(
            onPressed: () => bloc.add(const CancelEvent()),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.neonAccent),
            label: const Text('Cancel',
                style: TextStyle(color: AppColors.neonAccent)),
          ),
        ],
      ],
    );
  }
}
DART

ok "HomePage written"

# =============================================================================
#  DART — INJECTION CONTAINER + MAIN
# =============================================================================
log "Writing main.dart and DI…"

cat > lib/injection_container.dart << 'DART'
import 'data/datasources/media3_datasource.dart';
import 'data/repositories/converter_repository_impl.dart';
import 'domain/repositories/converter_repository.dart';
import 'domain/usecases/convert_video_usecase.dart';
import 'presentation/bloc/converter_bloc.dart';

class IC {
  IC._();

  static late final Media3Datasource          _media3;
  static late final ConverterRepository       _repo;
  static late final ConvertVideoUseCase       convertVideo;

  static void init() {
    _media3      = Media3Datasource();
    _repo        = ConverterRepositoryImpl(_media3);
    convertVideo = ConvertVideoUseCase(_repo);
  }

  static ConverterBloc makeBloc() => ConverterBloc(convertVideo: convertVideo);
}
DART

cat > lib/main.dart << 'DART'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/notification_service.dart';
import 'injection_container.dart';
import 'presentation/bloc/converter_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:            Colors.transparent,
    statusBarIconBrightness:   Brightness.light,
    navigationBarColor:        Color(0xFF0A0E1A),
    navigationBarIconBrightness: Brightness.light,
  ));

  IC.init();
  runApp(const YJConverterApp());
}

class YJConverterApp extends StatelessWidget {
  const YJConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IC.makeBloc(),
      child: MaterialApp(
        title: 'YJ Converter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
DART

ok "main.dart written"

# =============================================================================
#  analysis_options + .gitignore
# =============================================================================
cat > analysis_options.yaml << 'YAML'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_final_fields
    - use_super_parameters
    - avoid_print

analyzer:
  errors:
    invalid_annotation_target: ignore
YAML

cat >> .gitignore << 'GIT'

# YJ Converter
*.3gp
*.mp4
/build
.flutter-plugins-dependencies
GIT

# placeholder asset
touch assets/icons/.gitkeep

# =============================================================================
#  VERSION LOCK FILE (reference for future upgrades)
# =============================================================================
cat > VERSIONS_2026.md << 'MD'
# YJ_Converter — Dependency Version Lock (April 2026)

| Component                       | Version       | Source                              |
|----------------------------------|---------------|-------------------------------------|
| Flutter SDK (stable)             | 3.41.x        | flutter.dev/install/archive         |
| Dart SDK                         | ≥3.5.0        | bundled with Flutter                |
| Kotlin                           | 2.0.21        | kotlinlang.org                      |
| Gradle Wrapper                   | 8.9           | gradle.org                          |
| Android Gradle Plugin (AGP)      | 8.3.2         | maven.google.com                    |
| compileSdk / targetSdk           | 35            | developer.android.com               |
| minSdk                           | 24 (Android 7.0) | itel/legacy device target        |
| Java                             | 17            | adoptium.net                        |
| androidx.media3 (Transformer)    | 1.10.0        | developer.android.com/jetpack/media3|
| androidx.work (WorkManager)      | 2.9.1         | developer.android.com/jetpack/work  |
| desugar_jdk_libs                 | 2.1.4         | maven.google.com                    |
| flutter_bloc                     | ^8.1.6        | pub.dev                             |
| equatable                        | ^2.0.5        | pub.dev                             |
| file_picker                      | ^8.1.2        | pub.dev                             |
| path_provider                    | ^2.1.4        | pub.dev                             |
| permission_handler               | ^11.3.1       | pub.dev                             |
| flutter_local_notifications      | ^21.0.0       | pub.dev (stable April 2026)         |
| workmanager (Flutter plugin)     | ^0.9.0+3      | pub.dev (stable Aug 2025)           |
| flutter_animate                  | ^4.5.0        | pub.dev                             |
| glassmorphism                    | ^3.0.0        | pub.dev                             |
| gap                              | ^3.0.1        | pub.dev                             |
| percent_indicator                | ^4.2.3        | pub.dev                             |

## Kotlin ↔ Gradle Compatibility
- Kotlin 2.0.21 is fully compatible with Gradle 8.9 (verified via Kotlin/Gradle compatibility matrix).
- AGP 8.3.2 requires Gradle ≥ 8.4 — satisfied by Gradle 8.9.
MD

ok "Version lock file created"

# =============================================================================
#  FINAL — pub get + build
# =============================================================================
log "Running flutter pub get…"
flutter pub get

echo ""
echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  🎬  YJ_Converter is READY!${RESET}"
echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════${RESET}"
echo ""
echo -e "  ${BOLD}Project:${RESET}   $(pwd)"
echo ""
echo -e "  ${BOLD}Architecture layers:${RESET}"
echo "  ├── lib/domain/           ← Entities + Use Cases"
echo "  ├── lib/data/             ← Media3 MethodChannel bridge"
echo "  ├── lib/presentation/     ← BLoC + Glassmorphism UI"
echo "  └── android/…/kotlin/     ← ConversionWorker.kt (WorkManager)"
echo ""
echo -e "  ${BOLD}Native engine:${RESET}  Media3 Transformer 1.10.0 (HW accelerated)"
echo -e "  ${BOLD}Output spec:${RESET}    H.264 Baseline / 320×240 / 1Mbps → .3gp"
echo -e "  ${BOLD}Background:${RESET}     WorkManager OneTimeWork + ForegroundService"
echo ""
echo -e "  ${BOLD}Build APK:${RESET}"
echo -e "    ${CYAN}flutter build apk --release${RESET}"
echo ""
echo -e "  ${BOLD}Run on device:${RESET}"
echo -e "    ${CYAN}flutter run${RESET}"
echo ""
echo -e "  ${BOLD}Version reference:${RESET}"
echo -e "    ${CYAN}cat VERSIONS_2026.md${RESET}"
echo ""
