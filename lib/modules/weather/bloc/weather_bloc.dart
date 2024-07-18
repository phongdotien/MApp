import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/entities/weather.dart';
import 'package:flutterapp/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _repository;
  WeatherBloc(this._repository) : super(WeatherInitial()) {
    on<GetWeather>(_onGetWeather);
  }

  Future<void> _onGetWeather(
      GetWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    await _repository.fetchWeather(event.city).then((weather) {
      emit(WeatherLoaded(weather));
    }).catchError((error) {
      emit(WeatherError(error.toString()));
    });
  }
}
