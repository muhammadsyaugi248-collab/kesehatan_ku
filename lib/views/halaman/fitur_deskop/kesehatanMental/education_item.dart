// File: lib/widgets/education_item.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart';

class EducationItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const EducationItem({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    // Implementasi Item Edukasi Kesehatan
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Icons.psychology, color: kPrimaryColor, size: 30),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kTextColorDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: kTextColorLight),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 18, color: kIconColor),
        ],
      ),
    );
  }
}
