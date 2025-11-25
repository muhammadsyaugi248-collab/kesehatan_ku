import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/health_datamodel.dart';
import 'custom_card.dart';

// Impor widget pendukung yang sekarang publik dari health_widgets.dart
import 'health_widgets.dart';

// === HEALTH CARDS ===

class MedicalConditionsCard extends StatelessWidget {
  final List<MedicalCondition> conditions;
  const MedicalConditionsCard({super.key, required this.conditions});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.orange.shade500,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Kondisi Medis', // Diterjemahkan
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...conditions
              .map(
                (condition) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.orange.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.orange.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            condition.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          if (conditions.isEmpty)
            const Text(
              'Tidak ada kondisi medis aktif yang tercatat.',
            ), // Diterjemahkan
        ],
      ),
    );
  }
}

class AllergiesCard extends StatelessWidget {
  final List<Allergy> allergies;
  const AllergiesCard({super.key, required this.allergies});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                color: Colors.red.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Alergi', // Diterjemahkan
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (allergies.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              // Menggunakan widget AllergyChip dari health_widgets.dart
              children: allergies.map((a) => AllergyChip(allergy: a)).toList(),
            )
          else
            const Text(
              'Tidak ada alergi yang diketahui tercatat.',
            ), // Diterjemahkan
        ],
      ),
    );
  }
}

class DoctorsRecommendationsCard extends StatelessWidget {
  final List<Recommendation> recommendations;
  const DoctorsRecommendationsCard({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                color: Colors.blue.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Rekomendasi Dokter', // Diterjemahkan
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (recommendations.isNotEmpty)
            ...recommendations
                .map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    // Menggunakan widget RecommendationItem dari health_widgets.dart
                    child: RecommendationItem(recommendation: r),
                  ),
                )
                .toList()
          else
            const Text(
              'Tidak ada rekomendasi spesifik saat ini.',
            ), // Diterjemahkan
        ],
      ),
    );
  }
}
