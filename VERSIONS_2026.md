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
