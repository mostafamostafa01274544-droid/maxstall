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
