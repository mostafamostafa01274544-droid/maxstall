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
