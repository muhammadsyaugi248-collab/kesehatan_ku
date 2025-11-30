// lib/views/halaman/profile/profile_shared.dart

import 'package:flutter/material.dart';

/// ================== WARNA & GRADIENT ==================

const Color kProfileBg = Color.fromARGB(255, 201, 231, 226);
const Color kPrimaryTeal = Color(0xFF00A896);
const Color kPrimaryTealDark = Color(0xFF028090);
const Color kTextDark = Color(0xFF1F2937);
const Color kTextGrey = Color(0xFF6B7280);

const LinearGradient headerGradient = LinearGradient(
  colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Indikator naik / turun / perlu perhatian
Color trendColor(String change) {
  final text = change.trim().toLowerCase();

  if (text.startsWith('+')) {
    return Colors.green.shade600; // naik
  }
  if (text.startsWith('-')) {
    return Colors.red.shade600; // turun
  }
  if (text.contains('perhatian') ||
      text.contains('waspada') ||
      text.contains('high') ||
      text.contains('tinggi')) {
    return Colors.orange.shade700; // perlu perhatian
  }
  return kTextGrey;
}

/// ================== UTIL: LOADING DIALOG ==================

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        const Center(child: CircularProgressIndicator(strokeWidth: 4)),
  );
}

void hideLoadingDialog(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}

/// ================== MODEL: HEALTH STATS ==================

class HealthStats {
  final double weightKg;
  final double heightCm;
  final int systolic;
  final int diastolic;
  final double glucose; // mg/dL
  final double uricAcid; // mg/dL
  final double hdl;
  final double ldl;

  HealthStats({
    required this.weightKg,
    required this.heightCm,
    required this.systolic,
    required this.diastolic,
    required this.glucose,
    required this.uricAcid,
    required this.hdl,
    required this.ldl,
  });

  double get totalCholesterol => hdl + ldl;

  double? get bmi {
    if (weightKg <= 0 || heightCm <= 0) return null;
    final hM = heightCm / 100.0;
    return weightKg / (hM * hM);
  }

  Map<String, dynamic> toMap() {
    return {
      'weightKg': weightKg,
      'heightCm': heightCm,
      'systolic': systolic,
      'diastolic': diastolic,
      'glucose': glucose,
      'uricAcid': uricAcid,
      'hdl': hdl,
      'ldl': ldl,
      'totalCholesterol': totalCholesterol,
    };
  }

  factory HealthStats.fromMap(Map<String, dynamic> map) {
    return HealthStats(
      weightKg: (map['weightKg'] ?? 0).toDouble(),
      heightCm: (map['heightCm'] ?? 0).toDouble(),
      systolic: (map['systolic'] ?? 0) as int,
      diastolic: (map['diastolic'] ?? 0) as int,
      glucose: (map['glucose'] ?? 0).toDouble(),
      uricAcid: (map['uricAcid'] ?? 0).toDouble(),
      hdl: (map['hdl'] ?? 0).toDouble(),
      ldl: (map['ldl'] ?? 0).toDouble(),
    );
  }
}

/// Helper status – cuma buat tampilan, bukan diagnosis medis.
String classifyTotalCholesterol(double total) {
  if (total <= 0) return 'Tidak ada data';
  if (total < 200) return 'Baik';
  if (total < 240) return 'Perlu perhatian';
  return 'Tinggi';
}

String classifyGlucose(double g) {
  if (g <= 0) return 'Tidak ada data';
  if (g < 100) return 'Normal';
  if (g < 126) return 'Perlu perhatian';
  return 'Tinggi';
}

String classifyBloodPressure(int sys, int dia) {
  if (sys == 0 || dia == 0) return 'Tidak ada data';
  if (sys < 120 && dia < 80) return 'Normal';
  if (sys < 140 && dia < 90) return 'Perlu perhatian';
  return 'Tinggi';
}

String classifyUricAcid(double u) {
  if (u <= 0) return 'Tidak ada data';
  if (u <= 7.0) return 'Normal';
  return 'Tinggi';
}

Color statusColor(String status) {
  final s = status.toLowerCase();
  if (s.contains('baik') || s.contains('normal')) {
    return Colors.green.shade600;
  }
  if (s.contains('perhatian')) {
    return Colors.orange.shade700;
  }
  if (s.contains('tinggi')) {
    return Colors.red.shade600;
  }
  return kTextGrey;
}
