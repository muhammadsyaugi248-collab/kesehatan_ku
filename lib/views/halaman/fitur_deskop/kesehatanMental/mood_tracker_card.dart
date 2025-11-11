// File: mental_health_screen.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/education_item.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/fitur_kesehatan_mental/journal_screen.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/service_card.dart';
// Asumsikan struktur folder Anda menggunakan package import

// --- DEFINISI KONSTANTA WARNA (Global) ---
// Bagian ini sangat penting untuk diakses oleh file modular
const Color kPrimaryColor = Color(0xFF67B545);
const Color kSecondaryColor = Color(0xFFE8F5E9);
const Color kTextColorDark = Color(0xFF1F1F1F);
const Color kTextColorLight = Color(0xFF757575);
const Color kCardColor1 = Color(0xFFF9E7D8);
const Color kCardColor2 = Color(0xFFD6E6F5);
const Color kIconColor = Color(0xFF9E9E9E);
const Color kBackgroundColor = Color(0xFFFFFFFF);

// (Class MentalHealthScreen dan State-nya di sini)
// ... (omitted for brevity)

// Bagian yang dikoreksi: _buildPopularServices
Widget _buildPopularServices() {
  // Data service...
  final List<Map<String, dynamic>> services = const [
    {
      'title': 'Konsultasi Online',
      'icon': Icons.forum,
      'color': kCardColor1,
      'target': 'Consultation',
    },
    {
      'title': 'Jurnal Harian',
      'icon': Icons.book,
      'color': kCardColor2,
      'target': 'Journal',
    },
    {
      'title': 'Tes Kepribadian',
      'icon': Icons.assignment,
      'color': kCardColor1,
      'target': 'Test',
    },
  ];

  return SizedBox(
    height: 150,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: services.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        final service = services[index];

        return GestureDetector(
          onTap: () {
            if (service['target'] == 'Journal') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const JournalScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fitur ${service['title']} belum tersedia.'),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: index == services.length - 1 ? 0 : 16,
            ),
            // KOREKSI UTAMA: return ServiceCard (bukan Service)
            child: ServiceCard(
              title: service['title'] as String,
              icon: service['icon'] as IconData,
              cardColor: service['color'] as Color,
            ),
          ),
        );
      },
    ),
  );
}

// Bagian yang dikoreksi: _buildEducationCards
Widget _buildEducationCards() {
  final List<Map<String, dynamic>> educations = const [
    {'title': 'Cara Mengatasi Burnout', 'subtitle': '5 Menit membaca'},
    {'title': 'Tips Tidur Nyenyak', 'subtitle': '8 Menit mendengarkan'},
    {'title': 'Melawan Stres di Tempat Kerja', 'subtitle': '10 Menit membaca'},
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      // KOREKSI: EducationItem dipanggil dengan benar
      children: educations.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EducationItem(
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
          ),
        );
      }).toList(),
    ),
  );
}
// ... (sisa kode MentalHealthScreen)