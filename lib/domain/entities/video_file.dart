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
