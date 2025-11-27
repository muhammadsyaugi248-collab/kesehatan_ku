import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/health_datamodel.dart';
// ❌ import 'custom_card.dart';  // <- HAPUS, memang tidak dipakai

// Widget pendukung untuk alergi
class AllergyChip extends StatelessWidget {
  final Allergy allergy;

  const AllergyChip({super.key, required this.allergy});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        allergy.name,
        style: TextStyle(fontSize: 14, color: Colors.red.shade800),
      ),
      backgroundColor: Colors.red.shade100,
      side: BorderSide(color: Colors.red.shade400, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

// Widget pendukung untuk rekomendasi
class RecommendationItem extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationItem({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade400, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.blue.shade800,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recommendation.text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
