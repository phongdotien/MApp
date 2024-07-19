part of 'video_bloc.dart';

abstract class ProcessVideoEvent {}

class ProcessVideo extends ProcessVideoEvent {
  final String city;
  final String type;

  ProcessVideo(this.city, this.type);
}

class GetVideo extends ProcessVideoEvent {
}


