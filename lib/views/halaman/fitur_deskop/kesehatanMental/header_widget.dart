// File: lib/widgets/header_widget.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Implementasi Header (gunakan kPrimaryColor, kTextColorDark, dll.)
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, Jhon!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kTextColorDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Yuk jaga kesehatan mentalmu!',
                style: TextStyle(fontSize: 16, color: kTextColorLight),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_none,
              color: kPrimaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
