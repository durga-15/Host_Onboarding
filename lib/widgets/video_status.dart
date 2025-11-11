// video_status.dart

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../providers/video_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_gradient.dart';
import 'video_playback_screen.dart';

class VideoStatus extends ConsumerWidget {
  const VideoStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoProvider);
    final isRecording = videoState.isRecording;
    final isRecorded = videoState.isRecorded;
    final isConfirmRecording = videoState.isConfirmRecording;
    final duration = videoState.duration;

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
          if (isConfirmRecording && videoState.filePath != null)
            GestureDetector(
              onTap: () {
                // Play the recorded video
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlaybackScreen(
                      videoFilePath: videoState.filePath!,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video Thumbnail
                      FutureBuilder<Uint8List?>(
                        future: VideoThumbnail.thumbnailData(
                          video: videoState.filePath!,
                          imageFormat: ImageFormat.JPEG,
                          maxWidth: 200,
                          quality: 75,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: MemoryImage(snapshot.data!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
                      // Play Icon Overlaid
                      Icon(
                        Icons.play_circle_fill,
                        size: 30,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isRecording
                        ? 'Recording Video...'
                        : isConfirmRecording
                            ? 'Video Recorded'
                            : 'Confirm Recording',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.text1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
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
                  if (isRecorded) ...[
                    Text(
                      formatDuration(duration),
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.border3,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (isRecorded && isConfirmRecording)
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(videoProvider.notifier)
                            .deleteRecording();
                      },
                      child: const Icon(
                        CupertinoIcons.delete,
                        size: 20,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                ],
              ),
            ),
          if (isRecording)
            // Timer during recording
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatDuration(duration),
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
