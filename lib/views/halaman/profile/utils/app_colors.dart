import 'package:flutter/material.dart';

// --- CUSTOM COLOR DEFINITION (Deep Cyan/Teal) ---
// Warna kustom untuk Primary Color (Deep Cyan/Teal: 0xFF00838F)
const int customPrimaryColorValue = 0xFF00838F;
const MaterialColor customPrimaryColor = MaterialColor(
  customPrimaryColorValue,
  <int, Color>{
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    500: Color(customPrimaryColorValue), // Primary shade
    600: Color(0xFF00ACC1),
    700: Color(0xFF0097A7),
    800: Color(0xFF00838F), // A deep shade for accents
    900: Color(0xFF006064),
  },
);

// Gradient untuk header seperti pada desain
const LinearGradient headerGradient = LinearGradient(
  // Menggunakan warna yang lebih cerah: dari 500 ke 700 untuk kontras yang baik
  colors: [Color(0xFF00ACC1), Color(0xFF4DD0E1)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
