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
