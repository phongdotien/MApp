import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/modules/weather/bloc/weather_bloc.dart';
import 'package:flutterapp/modules/weather/view_model/weather_view_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  final _viewModel = WeatherViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cityController.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Screen"),
      ),
      body: BlocProvider.value(
        value: _viewModel.weatherBloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),
              ElevatedButton(
                onPressed: () {
                  _viewModel.weatherBloc.add(GetWeather(_cityController.text));
                },
                child: const Text("Get Weather"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
