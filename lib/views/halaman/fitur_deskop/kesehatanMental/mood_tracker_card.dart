// File: lib/widgets/mood_tracker_card.dart

import 'package:flutter/material.dart';
// WAJIB: Import file yang mendefinisikan konstanta warna (kPrimaryColor, dll.)
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart'; // Asumsi path Anda

class MoodTrackerCard extends StatelessWidget {
  // Menggunakan StatelessWidget
  // --- PARAMETER WAJIB DITAMBAHKAN ---
  final int selectedMoodIndex;
  final void Function(int) onMoodSelected;

  const MoodTrackerCard({
    super.key,
    required this.selectedMoodIndex,
    required this.onMoodSelected,
  });

  final List<IconData> moodIcons = const [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
  ];

  // Anda dapat menambahkan label yang sesuai
  final List<String> moodLabels = const [
    'Sangat Baik',
    'Baik',
    'Biasa',
    'Buruk',
    'Sangat Buruk',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(16),
          // FIX: Konstanta warna sekarang dikenali
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bagaimana perasaan Anda hari ini?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kTextColorDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(moodIcons.length, (index) {
                bool isSelected = index == selectedMoodIndex;
                return GestureDetector(
                  onTap: () => onMoodSelected(index), // Panggil callback
                  child: Column(
                    children: [
                      Icon(
                        moodIcons[index],
                        size: 35,
                        // FIX: Konstanta warna kPrimaryColor dan kIconColor dikenali
                        color: isSelected ? kPrimaryColor : kIconColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        moodLabels[index],
                        style: TextStyle(
                          fontSize: 10,
                          color: kTextColorLight,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
