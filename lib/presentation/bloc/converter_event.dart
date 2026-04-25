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
