import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host_onboarding/widgets/app_gradient.dart';

import '../providers/experience_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/experience_card.dart';
import '../widgets/wave_background_painter.dart';
import '../widgets/wavy_progress_bar.dart'; // Import the Wavy Progress Bar
import 'onboarding_question_screen.dart';

class ExperienceSelectionScreen extends ConsumerStatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  _ExperienceSelectionScreenState createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState
    extends ConsumerState<ExperienceSelectionScreen>
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
    final experiencesAsyncValue = ref.watch(experiencesProvider);
    final selectedIds = ref.watch(selectedExperienceIdsProvider);

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
            child: const WavyProgressBar(progress: 0.5),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Add the wave background as the bottom-most layer
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
                      // "01" Text
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          "01",
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppColors.text4,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          "What kind of experiences do you want to host?",
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.text1,
                            letterSpacing: 0.2,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      // Experience cards with horizontal scrolling
                      SizedBox(
                        height: 140,
                        child: experiencesAsyncValue.when(
                          data: (experiences) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: experiences.length,
                                itemBuilder: (context, index) {
                                  final experience = experiences[index];
                                  final isSelected = selectedIds.contains(
                                    experience.id,
                                  );
                                  return ExperienceCard(
                                    experience: experience,
                                    isSelected: isSelected,
                                    onTap: () {
                                      final ids = [...selectedIds];
                                      if (isSelected) {
                                        ids.remove(experience.id);
                                      } else {
                                        ids.add(experience.id);
                                      }
                                      ref
                                              .read(
                                                selectedExperienceIdsProvider
                                                    .notifier,
                                              )
                                              .state =
                                          ids;
                                    },
                                    index: index,
                                  );
                                },
                              ),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) =>
                              Center(child: Text('Error: $err')),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Multi-line TextField
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          height: _isKeyboardVisible
                              ? 100
                              : 160, // Adjust height
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite2,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: _isKeyboardVisible
                                  ? AppColors.primaryAccent
                                  : AppColors.border1,
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
                              hintText: '/ Describe your perfect hotspot',
                              hintStyle: AppTextStyles.bodyText.copyWith(
                                color: AppColors.text3,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                            onChanged: (value) =>
                                ref
                                        .read(experienceTextProvider.notifier)
                                        .state =
                                    value,
                            cursorColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Next Button
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: selectedIds.isNotEmpty
                                ? AppGradients.backgroundBlur
                                : null,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Same border radius
                              gradient: RadialGradient(
                                colors: selectedIds.isNotEmpty
                                    ? [
                                        Colors.white.withOpacity(0.2),
                                        Colors.black.withOpacity(0.1),
                                      ]
                                    : [
                                        Colors.white.withOpacity(0),
                                        Colors.black.withOpacity(0),
                                      ],
                                radius: 5,
                                center: Alignment.center,
                              ),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.text1, backgroundColor: Colors.transparent, // Text color
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: selectedIds.isNotEmpty
                                        ? AppColors.border3
                                        : AppColors.border1,
                                    width: 1.5,
                                  ),
                                ),
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: selectedIds.isNotEmpty
                                  ? () {
                                      final selectedIds = ref.read(
                                        selectedExperienceIdsProvider,
                                      );
                                      final text = ref.read(
                                        experienceTextProvider,
                                      );
                                      print('Selected IDs: $selectedIds');
                                      print('Additional Text: $text');
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => OnboardingQuestionScreen(),
                                          transitionsBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                              ) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                          transitionDuration: const Duration(
                                            milliseconds: 300,
                                          ),
                                        ),
                                      );
                                    }
                                  : null, // Disable button when inactive
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Next',
                                    style: AppTextStyles.bodyText.copyWith(
                                      color: Colors.white.withOpacity(
                                        selectedIds.isNotEmpty ? 0.9 : 0.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/forward.png',
                                    color: Colors.white.withOpacity(
                                      selectedIds.isNotEmpty ? 0.9 : 0.4,
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
