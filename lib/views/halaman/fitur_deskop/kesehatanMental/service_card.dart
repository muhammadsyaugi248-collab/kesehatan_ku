// File: lib/widgets/service_card.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color cardColor;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    // Implementasi Card Layanan Populer
    return Container(
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kBackgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kPrimaryColor, size: 24),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kTextColorDark,
            ),
          ),
          const Text(
            'Mulai sekarang',
            style: TextStyle(fontSize: 12, color: kTextColorLight),
          ),
        ],
      ),
    );
  }
}
