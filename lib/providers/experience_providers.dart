import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/experience.dart';
import 'api_providers.dart';

// FutureProvider to fetch experiences
final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchExperiences();
});

// StateProvider for selected experience IDs
final selectedExperienceIdsProvider = StateProvider<List<int>>((ref) => []);

// StateProvider for the text input
final experienceTextProvider = StateProvider<String>((ref) => '');
