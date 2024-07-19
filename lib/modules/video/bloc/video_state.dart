part of 'video_bloc.dart';

class VideoState extends Equatable {
  final List<String> videos;
  final String? status;

  const VideoState({
    this.videos = const [],
    this.status,
  });

  @override
  List<Object?> get props => [
        videos,
        status,
      ];

  VideoState copyWith({
    List<String>? videos,
    String? status,
  }) {
    return VideoState(
      videos: videos ?? this.videos,
      status: status ?? this.status,
    );
  }
}
