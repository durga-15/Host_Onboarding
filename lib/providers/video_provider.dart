// video_provider.dart

import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:video_player/video_player.dart';

final videoProvider = StateNotifierProvider<VideoNotifier, VideoState>(
  (ref) => VideoNotifier(),
);

class VideoState {
  final bool isRecording;
  final bool isRecorded;
  final bool isConfirmRecording;
  final String? filePath;
  final Duration duration;

  VideoState({
    this.isRecording = false,
    this.isRecorded = false,
    this.isConfirmRecording = false,
    this.filePath,
    this.duration = Duration.zero,
  });

  VideoState copyWith({
    bool? isRecording,
    bool? isRecorded,
    bool? isConfirmRecording,
    String? filePath,
    Duration? duration,
  }) {
    return VideoState(
      isRecording: isRecording ?? this.isRecording,
      isRecorded: isRecorded ?? this.isRecorded,
      isConfirmRecording: isConfirmRecording ?? this.isConfirmRecording,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
    );
  }
}

class VideoNotifier extends StateNotifier<VideoState> {
  VideoNotifier() : super(VideoState());

  Future<void> setRecordedVideo(String filePath) async {
    // Use video_player to get the duration
    final videoPlayerController = VideoPlayerController.file(File(filePath));
    try {
      await videoPlayerController.initialize();
      final videoDuration = videoPlayerController.value.duration;
      await videoPlayerController.dispose();

      state = state.copyWith(
        isRecording: false,
        isRecorded: true,
        isConfirmRecording: true,
        filePath: filePath,
        duration: videoDuration,
      );
    } catch (e) {
      print('Error getting video duration: $e');
      // Handle the error appropriately
    }
  }

  Future<void> deleteRecording() async {
    if (state.filePath != null) {
      final file = File(state.filePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    state = VideoState();
  }
}
