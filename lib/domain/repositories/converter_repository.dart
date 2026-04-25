import '../entities/conversion_result.dart';

abstract interface class ConverterRepository {
  Future<ConversionResult> convert({
    required String inputPath,
    required String outputPath,
    required String outputName,
  });
}
