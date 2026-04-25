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
