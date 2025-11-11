import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recording_providers.dart';
import '../providers/video_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_gradient.dart';
import '../widgets/recoding_card.dart';
import '../widgets/video_recoding_screen.dart';
import '../widgets/video_status.dart';
import '../widgets/wave_background_painter.dart';
import '../widgets/wavy_progress_bar.dart';

class OnboardingQuestionScreen extends ConsumerStatefulWidget {
  const OnboardingQuestionScreen({super.key});

  @override
  _OnboardingQuestionScreenState createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState
    extends ConsumerState<OnboardingQuestionScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (_isKeyboardVisible != newValue) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
      if (!_isKeyboardVisible) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(recordingProvider);
    final isRecordingAudio = recordingState.isRecording;
    final isRecordedAudio = recordingState.isRecorded;
    final isConfirmRecordingAudio = recordingState.isConfirmRecording;

    final videoState = ref.watch(videoProvider);
    final isRecordingVideo = videoState.isRecording;
    final isRecordedVideo = videoState.isRecorded;
    final isConfirmRecordingVideo = videoState.isConfirmRecording;

    // Adjust the text field height based on recording status
    double textFieldHeight = 250;
    if (isRecordingAudio ||
        isRecordedAudio ||
        isRecordingVideo ||
        isRecordedVideo) {
      textFieldHeight = 130; // Adjust as needed
    }

    // Determine if any recording is confirmed
    bool isAnyConfirmed = isConfirmRecordingAudio || isConfirmRecordingVideo;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.effectBgBlur80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text1),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.text1),
            onPressed: () {},
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            height: 20,
            child: const WavyProgressBar(progress: 0.7),
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: WaveBackgroundPainter(),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: _isKeyboardVisible ? 16 : 270),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "02" Text
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          "02",
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppColors.text4,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Question Title
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          "Why do you want to host with us?",
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.text1,
                            letterSpacing: 0.2,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Text(
                          "Tell us about your intent and what motivates you to create experiences.",
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      // Input Field with dynamic height
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          height: textFieldHeight,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite2,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: AppColors.border1,
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            focusNode: _focusNode,
                            maxLines: null,
                            style: AppTextStyles.bodyText.copyWith(
                              color: AppColors.text2,
                            ),
                            decoration: InputDecoration(
                              hintText: '/ Start typing here',
                              hintStyle: AppTextStyles.bodyText.copyWith(
                                color: AppColors.text3,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                            cursorColor: Colors.white,
                          ),
                        ),
                      ),
                      // Show the RecordingStatus widget
                      if (isRecordingAudio || isRecordedAudio)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                          ),
                          child: RecordingStatus(),
                        ),
                      // Show the VideoStatus widget
                      if (isRecordingVideo || isRecordedVideo)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                          ),
                          child: VideoStatus(),
                        ),
                      const SizedBox(height: 16),
                      // Bottom Button Bar
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          children: [
                            // Hide buttons when recording is confirmed
                            if (!isAnyConfirmed) ...[
                              // Audio Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (isRecordingAudio) {
                                      await ref
                                          .read(recordingProvider.notifier)
                                          .stopRecording();
                                    } else if (isRecordedAudio) {
                                      // Do nothing
                                    } else {
                                      try {
                                        await ref
                                            .read(recordingProvider.notifier)
                                            .startRecording();
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Microphone permission is required to record audio.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: isRecordingAudio
                                          ? AppGradients.radialGradientDark
                                          : null,
                                      border: Border.all(
                                        color: AppColors.border2,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Image.asset(
                                          'assets/mic.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Video Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      // Navigate to VideoRecorderScreen and wait for the recorded video file path
                                      String? videoFilePath =
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoRecorderScreen(),
                                            ),
                                          );
                                      if (videoFilePath != null) {
                                        // Update the video state with the recorded video
                                        ref
                                            .read(videoProvider.notifier)
                                            .setRecordedVideo(videoFilePath);
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Camera permission is required to record video.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: isRecordingVideo
                                          ? AppGradients.radialGradientDark
                                          : null,
                                      border: Border.all(
                                        color: AppColors.border2,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Image.asset(
                                          'assets/video.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                            // Next Button
                            Expanded(
                              flex: isAnyConfirmed ? 1 : 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppGradients.backgroundBlur,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // primary: Colors.transparent,
                                    // onPrimary: AppColors.text1,
                                    minimumSize: const Size(
                                      double.infinity,
                                      56,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 1.5,
                                      ),
                                    ),
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    // Add your navigation logic here
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next',
                                        style: AppTextStyles.bodyText.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
