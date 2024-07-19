


class VideoInfo {
  final String url;
  final String type;

  VideoInfo({
    required this.url,
    required this.type,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      VideoInfo(
        url: json['url'],
        type: json['type'],
      );
}
