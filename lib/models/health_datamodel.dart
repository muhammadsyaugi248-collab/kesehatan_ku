// Model Sederhana untuk merepresentasikan data yang akan ditampilkan

import 'package:flutter/material.dart';

class MedicalCondition {
  final String id;
  final String name;
  final String severity;

  const MedicalCondition({
    required this.id,
    required this.name,
    required this.severity,
  });
}

class Allergy {
  final String name;
  final String type;

  const Allergy({required this.name, required this.type});
}

class Recommendation {
  final String text;

  const Recommendation({required this.text});
}

class Goal {
  final String title;
  final double current;
  final double target;
  final String unit;

  const Goal({
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
  });

  // Getter untuk menghitung progress (selalu antara 0.0 dan 1.0)
  double get progress => (current / target).clamp(0.0, 1.0);
}

class VitalsComparison {
  final String label;
  final String value;
  final String change; // Contoh: '+0.5', '-1.2', 'Stable'
  final IconData icon;

  const VitalsComparison({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
  });
}

class Award {
  final IconData icon;
  final String title;
  final Color color;
  final Color iconColor;

  const Award({
    required this.icon,
    required this.title,
    required this.color,
    required this.iconColor,
  });
}
