import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/file_utils.dart';
import '../../core/services/notification_service.dart';
import '../../domain/usecases/convert_video_usecase.dart';

part 'converter_event.dart';
part 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final ConvertVideoUseCase convertVideo;

  ConverterBloc({required this.convertVideo})
      : super(const ConverterState()) {
    on<PickVideoEvent>         (_onPick);
    on<StartConversionEvent>   (_onConvert);
    on<ResetEvent>             (_onReset);
    on<CancelEvent>            (_onCancel);
    on<OutputNameChangedEvent> (_onNameChanged);
    on<OutputDirChangedEvent>  (_onDirChanged);
  }

  Future<void> _onPick(PickVideoEvent _, Emitter<ConverterState> emit) async {
    final permission = Platform.isAndroid
        ? (await _androidSdk() >= 33
            ? await Permission.videos.request()
            : await Permission.storage.request())
        : await Permission.storage.request();

    if (!permission.isGranted) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        errorMessage: const PermissionFailure().message,
      ));
      return;
    }

    final res = await FilePicker.platform.pickFiles(
      type: FileType.video, allowMultiple: false,
    );

    if (res == null || res.files.single.path == null) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        errorMessage: const FilePickFailure().message,
      ));
      return;
    }

    final path = res.files.single.path!;
    final defaultName = path.split('/').last.replaceAll(RegExp(r'\.\w+$'), '');

    emit(state.copyWith(
      status: ConversionStatus.picked,
      inputPath: path,
      outputName: defaultName,
      outputPath: null,
      progress: 0,
      errorMessage: null,
    ));
  }

  Future<void> _onConvert(
      StartConversionEvent _, Emitter<ConverterState> emit) async {
    if (state.inputPath == null) return;

    String outputPath;
    try {
      outputPath = await FileUtils.resolveOutputPath(
        sourcePath: state.inputPath!,
        customDir:  state.outputDir.isNotEmpty ? state.outputDir : null,
        customName: state.outputName.isNotEmpty ? state.outputName : null,
      );
    } catch (_) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        errorMessage: const OutputPathFailure().message,
      ));
      return;
    }

    emit(state.copyWith(
      status: ConversionStatus.converting,
      outputPath: outputPath,
      progress: 0,
    ));

    // Simulate indeterminate progress while WorkManager runs
    final progressTimer = _startProgressSimulation(emit);

    try {
      final result = await convertVideo(ConvertParams(
        inputPath:  state.inputPath!,
        outputPath: outputPath,
        outputName: state.outputName,
      ));
      progressTimer.cancel();

      await NotificationService.showSuccess(outputPath);

      emit(state.copyWith(
        status:    ConversionStatus.success,
        outputPath: result.outputPath,
        progress:  1.0,
        elapsed:   result.elapsed,
      ));
    } on ConversionFailure catch (e) {
      progressTimer.cancel();
      await NotificationService.showError(e.message);
      emit(state.copyWith(
          status: ConversionStatus.failure, errorMessage: e.message));
    } catch (e) {
      progressTimer.cancel();
      final msg = e.toString();
      await NotificationService.showError(msg);
      emit(state.copyWith(
          status: ConversionStatus.failure, errorMessage: msg));
    }
  }

  /// Simulates smooth progress (0 → 0.95) during background processing.
  Timer _startProgressSimulation(Emitter<ConverterState> emit) {
    double p = 0;
    return Timer.periodic(const Duration(milliseconds: 400), (t) {
      if (p < 0.95) {
        p = (p + 0.01).clamp(0.0, 0.95);
        if (!emit.isDone) emit(state.copyWith(progress: p));
      }
    });
  }

  void _onReset(ResetEvent _, Emitter<ConverterState> emit) =>
      emit(const ConverterState());

  void _onCancel(CancelEvent _, Emitter<ConverterState> emit) async {
    // Cancel native WorkManager job
    try {
      await convertVideo(const ConvertParams(
        inputPath: '', outputPath: '', outputName: 'cancel'));
    } catch (_) {}
    emit(const ConverterState());
  }

  void _onNameChanged(OutputNameChangedEvent e, Emitter<ConverterState> emit) =>
      emit(state.copyWith(outputName: e.name));

  void _onDirChanged(OutputDirChangedEvent e, Emitter<ConverterState> emit) =>
      emit(state.copyWith(outputDir: e.dir));

  Future<int> _androidSdk() async {
    try {
      final r = await Process.run('getprop', ['ro.build.version.sdk']);
      return int.tryParse(r.stdout.toString().trim()) ?? 0;
    } catch (_) { return 0; }
  }
}
