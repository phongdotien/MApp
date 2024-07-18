import 'package:flutterapp/entities/weather.dart';

import '../services/api_service.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository(this.apiService);

  Future<Weather> fetchWeather(String city) async {
    final response = await apiService
        .get('/data/2.5/weather?q=$city&appid=your_api_key&units=metric');
    return Weather.fromJson(response);
  }
}
