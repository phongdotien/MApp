part of 'weather_bloc.dart';

sealed class WeatherEvent {}

class GetWeather extends WeatherEvent {
  final String city;

  GetWeather(this.city);
}
