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
