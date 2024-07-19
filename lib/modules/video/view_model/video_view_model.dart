import 'package:flutterapp/config/app_config.dart';
import 'package:flutterapp/repositories/video_repository.dart';

import '../bloc/video_bloc.dart';

class GenerateViewModel {
  late final VideoBloc videoBloc;

  GenerateViewModel() {
    final generateRepository = VideoRepository(AppConfig.apiService);
    videoBloc = VideoBloc(generateRepository);
  }

  void fetchWeather(String city, String type) {
    videoBloc.add(ProcessVideo(city, type));
  }

  void dispose() {
    videoBloc.close();
  }
}
