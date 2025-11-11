// lib/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Text Colors
  static const Color text1 = Color(0xFFFFFFFF); // 100% opacity
  static Color text2 = const Color(0xFFFFFFFF).withOpacity(0.72); // 72% opacity
  static Color text3 = const Color(0xFFFFFFFF).withOpacity(0.48); // 48% opacity
  static Color text4 = const Color(0xFFFFFFFF).withOpacity(0.24); // 24% opacity

  // Base Colors
  static const Color base1 = Color(0xFF101010); // base dark
  static const Color base2 = Color(0xFF151515); // darker base

  // Surface Colors
  static Color surfaceWhite1 =
      const Color(0xFFFFFFFF).withOpacity(0.02); // 2% opacity
  static Color surfaceWhite2 =
      const Color(0xFFFFFFFF).withOpacity(0.06); // 6% opacity
  static Color surfaceBlack1 =
      const Color(0xFF101010).withOpacity(0.90); // 90% opacity
  static Color surfaceBlack2 =
      const Color(0xFF101010).withOpacity(0.70); // 70% opacity
  static Color surfaceBlack3 =
      const Color(0xFF101010).withOpacity(0.50); // 50% opacity

  // Accent Colors
  static const Color primaryAccent = Color(0xFF919BFF); // blue accent
  static const Color secondaryAccent =
      Color(0xFF69B6FF); // secondary blue accent
  static const Color positive = Color(0xFF5BDDAA); // green for positive actions
  static const Color negative = Color(0xFFC22743); // red for negative actions

  // Borders
  static Color border1 = const Color(0xFFFFFFFF).withOpacity(0.08); // border 1
  static Color border2 = const Color(0xFFFFFFFF).withOpacity(0.16); // border 2
  static Color border3 = const Color(0xFFFFFFFF).withOpacity(0.24); // border 3
  // Borders with gradient from white to black
  static final BoxDecoration borderGradient = BoxDecoration(
    borderRadius: BorderRadius.circular(12), // Customize as needed
    border: Border.all(
      width: 1.5, // Border width
      style: BorderStyle.solid,
      color: Colors.transparent, // Transparent to allow gradient to show
    ),
    gradient: const LinearGradient(
      colors: [Colors.white, Colors.black], // Gradient from white to black
      begin: Alignment.topLeft, // Start the gradient at the top left
      end: Alignment.bottomRight, // End the gradient at the bottom right
    ),
  );

  // Effects
  static Color effectBgBlur12 =
      const Color(0xFF101010).withOpacity(0.12); // background blur 12
  static Color effectBgBlur40 =
      const Color(0xFF101010).withOpacity(0.40); // background blur 40
  static Color effectBgBlur80 =
      const Color(0xFF141414).withOpacity(0.80); // background blur 80
}
