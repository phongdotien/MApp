import 'package:flutterapp/config/app_config.dart';
import 'package:flutterapp/repositories/weather_repository.dart';

import '../bloc/weather_bloc.dart';

class WeatherViewModel {
  late final WeatherBloc weatherBloc;

  WeatherViewModel() {
    final weatherRepository = WeatherRepository(AppConfig.apiService);
    weatherBloc = WeatherBloc(weatherRepository);
  }

  void fetchWeather(String city) {
    weatherBloc.add(GetWeather(city));
  }

  void dispose() {
    weatherBloc.close();
  }
}
