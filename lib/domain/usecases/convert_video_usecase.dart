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
