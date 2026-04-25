import 'data/datasources/media3_datasource.dart';
import 'data/repositories/converter_repository_impl.dart';
import 'domain/repositories/converter_repository.dart';
import 'domain/usecases/convert_video_usecase.dart';
import 'presentation/bloc/converter_bloc.dart';

class IC {
  IC._();

  static late final Media3Datasource          _media3;
  static late final ConverterRepository       _repo;
  static late final ConvertVideoUseCase       convertVideo;

  static void init() {
    _media3      = Media3Datasource();
    _repo        = ConverterRepositoryImpl(_media3);
    convertVideo = ConvertVideoUseCase(_repo);
  }

  static ConverterBloc makeBloc() => ConverterBloc(convertVideo: convertVideo);
}
