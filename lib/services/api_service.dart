// lib/services/api_service.dart

import 'package:dio/dio.dart';

import '../models/experience.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Experience>> fetchExperiences() async {
    const String url =
        'https://staging.chamberofsecrets.8club.co/v1/experiences?active=true';
    try {
      print("hello");
      final response = await _dio.get(url);
      print('Response status: ${response.statusCode}');
      print('Response error: ${response.data}');
      print("responsedata");
      final data = response.data['data']['experiences'] as List;
      // print('Extracted experiences data: $data');

      return data.map((e) => Experience.fromJson(e)).toList();
    } catch (e) {
      print("pqr ${e}");
      throw Exception('Failed to load experiences');
    }
  }
}
