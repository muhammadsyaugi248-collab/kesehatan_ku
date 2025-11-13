import 'package:flutter/material.dart';

// Ekstensi untuk menggelapkan warna
extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

// Fungsi pembantu untuk menampilkan pesan singkat (SnackBar)
void showAppSnackBar(
  BuildContext context,
  String message, {
  Color color = Colors.teal,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
