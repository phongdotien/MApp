import 'package:flutterapp/entities/video.dart';

import '../services/api_service.dart';

class VideoRepository {
  final ApiService apiService;

  VideoRepository(this.apiService);

Future<List<String>> getVideos() async {
    final response = await apiService.get('/list_videos');
    if (response is List) {
      return response.map((video) => video.toString()).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }
Future<VideoInfo> createVideos(String url, String type) async {
    final response = await apiService.post('/generateVideo', {
      'url': url,
      'type': type,
    });
    return VideoInfo.fromJson(response);
  }
}
