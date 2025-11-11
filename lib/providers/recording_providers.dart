// recording_providers.dart

import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final recordingProvider =
    StateNotifierProvider<RecordingNotifier, RecordingState>(
  (ref) => RecordingNotifier(),
);

class RecordingState {
  RecordingState copyWith({
    bool? isRecording,
    bool? isRecorded,
    bool? isConfirmRecording,
    bool? isPlaying,
    String? filePath,
    Duration? duration,
  }) {
    return RecordingState(
      isRecording: isRecording ?? this.isRecording,
      isRecorded: isRecorded ?? this.isRecorded,
      isConfirmRecording: isConfirmRecording ?? this.isConfirmRecording,
      isPlaying: isPlaying ?? this.isPlaying,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
    );
  }

  final bool isRecording;
  final bool isRecorded;
  final bool isConfirmRecording;
  final bool isPlaying; // New state to track playback
  final String? filePath;
  final Duration duration;

  RecordingState({
    this.isRecording = false,
    this.isRecorded = false,
    this.isConfirmRecording = false,
    this.isPlaying = false,
    this.filePath,
    this.duration = Duration.zero,
  });
}

class RecordingNotifier extends StateNotifier<RecordingState> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player; // Add a player instance

  RecordingNotifier() : super(RecordingState()) {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer(); // Initialize the player
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
    await _player!.openPlayer(); // Open the audio player
    _recorder!.setSubscriptionDuration(const Duration(milliseconds: 50));
  }

  Future<void> startRecording() async {
    try {
      // Request microphone permission
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }

      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/recorded_audio.aac';

      await _recorder!.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      state = RecordingState(
        isRecording: true,
        isRecorded: false,
        isConfirmRecording: false,
        isPlaying: false,
        filePath: path,
        duration: Duration.zero,
      );

      _recorder!.onProgress!.listen((event) {
        state = RecordingState(
          isRecording: true,
          isRecorded: false,
          isConfirmRecording: false,
          isPlaying: false,
          filePath: path,
          duration: event.duration,
        );
      });
    } catch (e) {
      print('Error starting recorder: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recorder!.stopRecorder();
      state = RecordingState(
        isRecording: false,
        isRecorded: true,
        isConfirmRecording: false,
        isPlaying: false,
        filePath: state.filePath,
        duration: state.duration,
      );
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  Future<void> confirmRecording() async {
    state = RecordingState(
      isRecording: false,
      isRecorded: true,
      isConfirmRecording: true,
      isPlaying: false,
      filePath: state.filePath,
      duration: state.duration,
    );
  }

  Future<void> playRecording() async {
    if (state.filePath != null && !_player!.isPlaying) {
      await _player!.startPlayer(
        fromURI: state.filePath,
        codec: Codec.aacADTS,
        whenFinished: () {
          state = state.copyWith(isPlaying: false);
        },
      );
      state = state.copyWith(isPlaying: true);
    } else {
      await _player!.stopPlayer();
      state = state.copyWith(isPlaying: false);
    }
  }

  Future<void> deleteRecording() async {
    try {
      if (state.filePath != null) {
        final file = File(state.filePath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      state = RecordingState();
    } catch (e) {
      print('Error deleting recording: $e');
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    _recorder = null;
    _player = null;
    super.dispose();
  }
}
