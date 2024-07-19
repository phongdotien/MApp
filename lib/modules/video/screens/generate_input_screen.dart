import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutterapp/modules/video/bloc/video_bloc.dart';
import 'package:flutterapp/modules/video/view_model/video_view_model.dart';
import 'package:flutterapp/config/app_config.dart';

class GenerateInputScreen extends StatefulWidget {
  const GenerateInputScreen({super.key});

  @override
  State<GenerateInputScreen> createState() => _GenerateInputScreenState();
}

class _GenerateInputScreenState extends State<GenerateInputScreen> {
  final TextEditingController _cityController = TextEditingController();
  final _viewModel = GenerateViewModel();
  String _selectedType = 'overthinking';
  VideoPlayerController? _videoController;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  void initState() {
    super.initState();
    _viewModel.videoBloc.add(GetVideo());
  }

  @override
  void dispose() {
    super.dispose();
    _cityController.dispose();
    _viewModel.dispose();
    _videoController?.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> _resizeVideo(String url) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String outputPath = '${tempDir.path}/output.mp4';

    await _flutterFFmpeg.execute(
      '-i $url -vf scale=640:360 $outputPath',
    ).then((rc) => print("FFmpeg process exited with rc $rc"));

    return outputPath;
  }

  Future<void> _playVideo(String url) async {
    _videoController?.dispose();
    String resizedUrl = await _resizeVideo(url);
    _videoController = VideoPlayerController.file(File(resizedUrl))
      ..initialize().then((_) {
        setState(() {});
        _videoController?.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Video From URL"),
      ),
      body: BlocProvider.value(
        value: _viewModel.videoBloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "URL here"),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: "Type"),
                items: <String>['overthinking', 'game', 'hot'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _viewModel.videoBloc.add(ProcessVideo(_cityController.text, _selectedType));
                  },
                  child: const Text("Generate Videos"),
                ),
              ),
              const SizedBox(height: 20),
              const Text("List Video"),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state.status == 'loading') {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state.status == 'error') {
                          return const Center(child: Text("Failed to load videos"));
                        } else if (state.videos.isEmpty) {
                          return const Center(child: Text("No videos available"));
                        } else {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.videos.length,
                              itemBuilder: (context, index) {
                                final videoUrl = '${AppConfig.apiService.baseUrl}/download/${state.videos[index]}';
                                return ListTile(
                                  title: Text(state.videos[index]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        onPressed: () {
                                          _playVideo(videoUrl);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.download),
                                        onPressed: () {
                                          _launchURL(videoUrl);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_videoController != null && _videoController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _viewModel.videoBloc.add(GetVideo());
                  },
                  child: const Text("Refresh"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
