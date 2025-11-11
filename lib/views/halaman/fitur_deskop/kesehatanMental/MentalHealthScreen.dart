// File: lib/mental_health_screen.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/education_item.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/fitur_kesehatan_mental/journal_screen.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/header_widget.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/mood_tracker_card.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/service_card.dart';
// Import semua widget modular dari folder widgets/
import 'widgets/education_item.dart';
import 'widgets/header_widget.dart';
import 'widgets/mood_tracker_card.dart';
import 'widgets/service_card.dart';

// Import JournalScreen untuk navigasi
import 'journal_screen.dart';

// --- DEFINISI KONSTANTA WARNA (Global) ---
const Color kPrimaryColor = Color(0xFF67B545); // Hijau Utama
const Color kSecondaryColor = Color(0xFFE8F5E9); // Latar Belakang Hijau Muda
const Color kTextColorDark = Color(0xFF1F1F1F);
const Color kTextColorLight = Color(0xFF757575);
const Color kCardColor1 = Color(0xFFF9E7D8);
const Color kCardColor2 = Color(0xFFD6E6F5);
const Color kIconColor = Color(0xFF9E9E9E);
const Color kBackgroundColor = Color(0xFFFFFFFF);

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  int _selectedMoodIndex = 0;

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

  final List<Map<String, dynamic>> educations = const [
    {'title': 'Cara Mengatasi Burnout', 'subtitle': '5 Menit membaca'},
    {'title': 'Tips Tidur Nyenyak', 'subtitle': '8 Menit mendengarkan'},
    {'title': 'Melawan Stres di Tempat Kerja', 'subtitle': '10 Menit membaca'},
  ];

  void _updateMood(int index) {
    setState(() {
      _selectedMoodIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Layanan Kesehatan Mental',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTextColorDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              MoodTrackerCard(
                selectedMoodIndex: _selectedMoodIndex,
                onMoodSelected: _updateMood,
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Layanan Populer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kTextColorDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildPopularServices(),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Edukasi Kesehatan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kTextColorDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildEducationCards(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularServices() {
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

  Widget _buildEducationCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
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
}
