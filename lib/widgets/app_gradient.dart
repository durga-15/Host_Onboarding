import 'package:flutter/material.dart';

class AppGradients {
  // Radial gradient from the first screenshot
  static RadialGradient radialGradientLight = RadialGradient(
    colors: [
      const Color(0xFF222222).withOpacity(0.20), // #222222 at 20% opacity
      const Color(0xFF999999).withOpacity(0.20), // #999999 at 20% opacity
      const Color(0xFF222222).withOpacity(0.20), // #222222 at 20% opacity
    ],
    radius: 0.5,
    center: Alignment.topLeft, // Align the gradient to the center
  );

  // Radial gradient from the second screenshot (with different opacity values)
  static RadialGradient radialGradientDark = RadialGradient(
    colors: [
      const Color(0xFF222222).withOpacity(0.40), // #222222 at 40% opacity
      const Color(0xFF999999).withOpacity(0.40), // #999999 at 40% opacity
      const Color(0xFF222222).withOpacity(0.40), // #222222 at 40% opacity
    ],
    radius: 3,
    center: Alignment.topLeft, // Align the gradient to the center
  );

  // Linear gradient for the top-side border
  static LinearGradient topBorderGradient = LinearGradient(
    colors: [
      const Color(0xFFFFFFFF).withOpacity(0.08), // White with 8% opacity
      Colors.transparent, // Transparent for fade effect
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Background blur gradient (for shadows and blur effects)
  static LinearGradient backgroundBlur = LinearGradient(
    colors: [
      const Color(0x00222222).withOpacity(0.40), // Darker background with 40% opacity
      const Color(0x00999999).withOpacity(0.40), // Grey with 40% opacity
      const Color(0x00222222).withOpacity(0.40), // Dark background with 40% opacity
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
