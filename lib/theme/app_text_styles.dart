// lib/theme/app_text_styles.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Heading Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 36 / 28, // line-height / font-size
    letterSpacing: -3, // -3% letter spacing
    color: AppColors.text1,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 30 / 24,
    letterSpacing: -2, // -2% letter spacing
    color: AppColors.text1,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 26 / 20,
    letterSpacing: -1, // -1% letter spacing
    color: AppColors.text1,
  );

  // Body Text Styles
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 24 / 16,
    letterSpacing: 0, // No letter spacing
    color: AppColors.text1,
  );

  static TextStyle subtextBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    height: 16 / 12,
    letterSpacing: 0, // No letter spacing
    color: AppColors.text2,
  );

  static TextStyle bodyRegular = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 14 / 10,
    letterSpacing: 0, // No letter spacing
    color: AppColors.text3,
  );
}
