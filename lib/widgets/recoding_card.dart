// recording_status.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recording_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_gradient.dart';

class RecordingStatus extends ConsumerWidget {
  const RecordingStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recordingProvider);
    final isRecording = recordingState.isRecording;
    final isRecorded = recordingState.isRecorded;
    final isConfirmRecording = recordingState.isConfirmRecording;
    final isPlaying = recordingState.isPlaying;
    final duration = recordingState.duration;

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: AppGradients.radialGradientDark,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recording text
          Row(
            children: [
              Text(
                isRecording
                    ? 'Recording Audio...'
                    : isConfirmRecording
                        ? 'Audio Recorded'
                        : 'Confirm Recording',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.text1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              if (isRecorded) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border3,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatDuration(duration),
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.border3,
                  ),
                ),
              ],
              const Spacer(),
              if (isRecorded || isConfirmRecording)
                GestureDetector(
                  onTap: () async {
                    await ref
                        .read(recordingProvider.notifier)
                        .deleteRecording();
                  },
                  child: const Icon(
                    CupertinoIcons.delete,
                    size: 15,
                    color: AppColors.primaryAccent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 25),
          // Row for Mic Icon, Audio Wave, and Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon based on state
              GestureDetector(
                onTap: () async {
                  if (isRecording) {
                    await ref.read(recordingProvider.notifier).stopRecording();
                  } else if (isRecorded && !isConfirmRecording) {
                    await ref
                        .read(recordingProvider.notifier)
                        .confirmRecording();
                  } else if (isConfirmRecording) {
                    await ref.read(recordingProvider.notifier).playRecording();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isRecording
                        ? AppColors.primaryAccent
                        : const Color(0xFF5961FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRecording
                        ? Icons.mic
                        : isConfirmRecording
                            ? (isPlaying ? Icons.pause : Icons.play_arrow)
                            : Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Audio Wave or Playback Progress
              Expanded(
                child: isRecording
                    ? _buildAudioWave()
                    : isConfirmRecording
                        ? _buildPlaybackProgress(isPlaying)
                        : _buildAudioWave(),
              ),
              // Timer during recording
              if (isRecording)
                Text(
                  formatDuration(duration),
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to build the audio wave bars
  Widget _buildAudioWave() {
    // List of heights to simulate the audio wave
    List<double> waveHeights = [
      10,
      20,
      15,
      25,
      10,
      20,
      15,
      30,
      15,
      20,
      10,
      25,
      10,
      20,
      15,
      25,
      10,
      20,
      15,
      30,
      15,
      20,
      10,
      25,
      25,
      10,
      20,
      15,
      25,
      10,
      25,
      10,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: waveHeights.map((height) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            width: 3,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.5),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper function to build playback progress indicator
  Widget _buildPlaybackProgress(bool isPlaying) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white.withOpacity(0.3),
      valueColor: AlwaysStoppedAnimation<Color>(
          isPlaying ? AppColors.primaryAccent : Colors.transparent),
      value: isPlaying ? null : 0,
    );
  }
}
