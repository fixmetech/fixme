import 'package:flutter/material.dart';

class FixMeColors {
  FixMeColors._();

  // App Basic Colors
  static const Color primary = Color.fromARGB(255, 23, 87, 225);        // Modern blue
  static const Color secondary = Color(0xFF06B6D4);      // Cyan accent
  static const Color accent = Color(0xFF3B82F6);         // Bright blue
  static const Color tertiary = Color(0xFF8B5CF6);       // Purple accent

  // Primary Variations
  static const Color primaryLight = Color(0xFF60A5FA);   // Light blue
  static const Color primaryDark = Color(0xFF1D4ED8);    // Dark blue
  static const Color primarySoft = Color(0xFFDBEAFE);    // Very light blue

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);    // Dark gray
  static const Color textSecondary = Color(0xFF6B7280);  // Medium gray
  static const Color textTertiary = Color(0xFF9CA3AF);   // Light gray
  static const Color textWhite = Colors.white;
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFFAFAFA);          // Very light gray
  static const Color dark = Color(0xFF1F2937);           // Dark gray
  static const Color primaryBackground = Color(0xFFF0F9FF); // Light blue tint

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF8FAFC); // Light container
  static const Color darkContainer = Color(0xFF374151);  // Dark container
  static const Color primaryContainer = Color(0xFFE0F2FE); // Primary container

  // Surface Colors
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceDim = Color(0xFFE2E8F0);
  static const Color surfaceBright = Color(0xFFFEFEFE);

  // Border Colors
  static const Color borderPrimary = Color(0xFFE5E7EB);  // Light border
  static const Color borderSecondary = Color(0xFFD1D5DB); // Medium border
  static const Color borderFocus = Color(0xFF3B82F6);    // Focus border (blue)

  // Status Colors
  static const Color success = Color(0xFF10B981);        // Green
  static const Color warning = Color(0xFFF59E0B);        // Amber
  static const Color error = Color(0xFFEF4444);          // Red
  static const Color info = Color(0xFF3B82F6);           // Blue

  // Status Background Colors
  static const Color successBackground = Color(0xFFECFDF5);
  static const Color warningBackground = Color(0xFFFEF3C7);
  static const Color errorBackground = Color(0xFFFEE2E2);
  static const Color infoBackground = Color(0xFFEFF6FF);

  // Interactive Colors
  static const Color buttonPrimary = Color(0xFF2563EB);
  static const Color buttonSecondary = Color(0xFFF8FAFC);
  static const Color buttonDisabled = Color(0xFFE5E7EB);
  static const Color buttonHover = Color(0xFF1D4ED8);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Advanced Gradient Collections
  static const LinearGradient blueOcean = LinearGradient(
    colors: [Color(0xFF1E40AF), Color(0xFF06B6D4), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyBlue = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8), Color(0xFF7DD3FC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient deepBlue = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient electricBlue = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient iceBlue = LinearGradient(
    colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD), Color(0xFF7DD3FC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient midnight = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGlass = LinearGradient(
    colors: [Color(0x80DBEAFE), Color(0x80BFDBFE), Color(0x8093C5FD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aquaMarine = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF14B8A6), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Radial Gradients
  static const RadialGradient primaryRadial = RadialGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB), Color(0xFF1D4ED8)],
    center: Alignment.center,
    radius: 0.8,
  );

  static const RadialGradient lightRadial = RadialGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    center: Alignment.center,
    radius: 1.0,
  );

  static const RadialGradient blueRadial = RadialGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF1E40AF)],
    center: Alignment.topLeft,
    radius: 1.2,
  );

  // Sweep Gradients
  static const SweepGradient primarySweep = SweepGradient(
    colors: [
      Color(0xFF2563EB),
      Color(0xFF3B82F6),
      Color(0xFF60A5FA),
      Color(0xFF93C5FD),
      Color(0xFF2563EB),
    ],
    center: Alignment.center,
  );

  static const SweepGradient rainbowBlue = SweepGradient(
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF06B6D4),
      Color(0xFF8B5CF6),
      Color(0xFF3B82F6),
    ],
    center: Alignment.center,
  );

  // Animated Gradient (for shimmer effects)
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE5E7EB),
      Color(0xFFF3F4F6),
      Color(0xFFE5E7EB),
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // Button Specific Gradients
  static const LinearGradient buttonPrimaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonSecondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonDisabledGradient = LinearGradient(
    colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Card Gradients
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardHoverGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Gradients
  static const LinearGradient backgroundLight = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundDark = LinearGradient(
    colors: [Color(0xFF1F2937), Color(0xFF111827)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x0F000000);    // 6% opacity
  static const Color shadowMedium = Color(0x1A000000);   // 10% opacity
  static const Color shadowDark = Color(0x33000000);     // 20% opacity

  // Divider Colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerMedium = Color(0xFFD1D5DB);
  static const Color dividerDark = Color(0xFF9CA3AF);

  // Icon Colors
  static const Color iconPrimary = Color(0xFF374151);
  static const Color iconSecondary = Color(0xFF6B7280);
  static const Color iconTertiary = Color(0xFF9CA3AF);
  static const Color iconOnPrimary = Colors.white;

  // Overlay Colors
  static const Color overlayLight = Color(0x1A000000);   // 10% opacity
  static const Color overlayMedium = Color(0x4D000000);  // 30% opacity
  static const Color overlayDark = Color(0x66000000);    // 40% opacity
}