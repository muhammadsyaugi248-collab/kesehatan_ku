import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/health_data.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/color_extensions.dart';
// Menggunakan path relatif untuk impor lokal

import 'custom_card.dart';

// === Goals Tab Widgets ===

class GoalProgressCard extends StatelessWidget {
  final Goal goal;

  const GoalProgressCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                goal.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              // Menampilkan nilai saat ini/target dengan format yang benar
              '${goal.current.toStringAsFixed(goal.unit == 'kg' ? 0 : 1)}/${goal.target.toStringAsFixed(goal.unit == 'kg' ? 0 : 1)} ${goal.unit}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progress,
          backgroundColor: Colors.grey.shade200,
          // Menggunakan warna primer dari tema (Biru/Teal)
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
        const SizedBox(height: 5),
        Text(
          '${(goal.progress * 100).toStringAsFixed(0)}% complete',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class ComparisonRow extends StatelessWidget {
  final VitalsComparison comparison;

  const ComparisonRow({super.key, required this.comparison});

  @override
  Widget build(BuildContext context) {
    Color changeColor = Colors.grey.shade500;
    // Menentukan warna berdasarkan perubahan (naik/turun/stabil)
    // Dibiarkan Merah/Hijau untuk representasi Kesehatan (Buruk/Baik), bukan warna tema.
    if (comparison.change.startsWith('+')) {
      changeColor =
          Colors.red.shade600; // Merah untuk kenaikan (biasanya buruk)
    } else if (comparison.change.startsWith('-')) {
      changeColor = Colors
          .green
          .shade600; // Hijau untuk penurunan (biasanya baik, misal BB)
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(comparison.icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              comparison.label,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ),
          Text(
            comparison.value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 8),
          if (comparison.change != 'Stable')
            Icon(
              comparison.change.startsWith('+')
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 14,
              color: changeColor,
            ),
          Text(
            comparison.change,
            style: TextStyle(
              fontSize: 14,
              color: changeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// === Awards Tab Widgets ===

class AwardTile extends StatelessWidget {
  final Award award;

  const AwardTile({super.key, required this.award});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: award.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: award.iconColor.withOpacity(0.5), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(award.icon, size: 40, color: award.iconColor),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              award.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                // Menggunakan ColorBrightness extension dari color_extensions.dart
                color: award.iconColor.darken(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
