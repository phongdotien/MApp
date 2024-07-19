import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/repositories/video_repository.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<ProcessVideoEvent, VideoState> {
  final VideoRepository _repository;
  VideoBloc(this._repository) : super(const VideoState()) {
    on<GetVideo>(_onGetVideos);
    on<ProcessVideo>(_onProcessVideo);
  }

  Future<void> _onGetVideos(GetVideo event, Emitter<VideoState> emit) async {
    emit(state.copyWith(status: 'loading'));
    try {
      final videos = await _repository.getVideos();
      emit(state.copyWith(videos: videos, status: 'success'));
    } catch (error) {
      emit(state.copyWith(status: 'error'));
    }
  }

  FutureOr<void> _onProcessVideo(
      ProcessVideo event, Emitter<VideoState> emit) {}

  
}
