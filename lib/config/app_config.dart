import 'package:flutterapp/services/api_service.dart';

class AppConfig {
  static ApiService apiService =
      ApiService(baseUrl: 'http://api.openweathermap.org');
}
