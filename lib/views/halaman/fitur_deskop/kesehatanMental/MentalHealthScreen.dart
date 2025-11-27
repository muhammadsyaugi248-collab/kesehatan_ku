import 'package:flutter/material.dart';

// ====== WARNA TEMA UTAMA (sesuai app kamu) ======
const Color _pageBackground = Color.fromARGB(255, 201, 231, 226);
const Color _primaryTeal = Color(0xFF00A896);
const Color _primaryTealDark = Color(0xFF028090);
const Color _softPurple = Color(0xFF7F7FF5);
const Color _softLavender = Color(0xFFC7BCFF);
const Color _textDark = Color(0xFF1F2937);
const Color _textGrey = Color(0xFF6B7280);

// ====== DATA MODEL SEDERHANA UNTUK MEDITASI ======
class MeditationItem {
  final String title;
  final String category;
  final String duration;
  final bool isGuided;

  const MeditationItem({
    required this.title,
    required this.category,
    required this.duration,
    this.isGuided = false,
  });
}

// Dummy data (bisa kamu ganti dari API / database)
const List<MeditationItem> _meditations = [
  MeditationItem(
    title: 'Morning Meditation',
    category: 'Breathing',
    duration: '10 min',
  ),
  MeditationItem(
    title: 'Sleep Sounds',
    category: 'Relaxation',
    duration: '20 min',
  ),
  MeditationItem(
    title: 'Stress Relief',
    category: 'Guided',
    duration: '15 min',
    isGuided: true,
  ),
];

// =======================
//   MAIN SCREEN WIDGET
// =======================
class MentalHealthScreen extends StatelessWidget {
  const MentalHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== Back to Dashboard ======
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back, size: 24, color: _textDark),
                      SizedBox(width: 6),
                      Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ====== Title & Subtitle ======
              const Text(
                'Kesehatan Mental',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track your mental wellbeing',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 20),

              // ====== Mood Header Card (gradient hijau–ungu lembut) ======
              buildMoodHeaderCard(),

              const SizedBox(height: 24),

              // ====== Section: Meditation & Relaxation ======
              const Text(
                'Meditation & Relaxation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),

              // List card meditasi
              Column(
                children: _meditations
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MeditationCard(item: item),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================
//   MENTAL HEALTH HEADER
// =======================
Widget buildMoodHeaderCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      // GRADIENT LEMBUT: teal → purple → lavender
      gradient: const LinearGradient(
        colors: [_primaryTeal, _softPurple, _softLavender],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: _softPurple.withOpacity(0.25),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.self_improvement,
                color: Colors.white,
                size: 28,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track your mood daily',
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _MoodOption(icon: '😊', label: 'Great'),
            _MoodOption(icon: '🙂', label: 'Good'),
            _MoodOption(icon: '😐', label: 'Okay'),
            _MoodOption(icon: '😔', label: 'Low'),
            _MoodOption(icon: '😭', label: 'Bad'),
          ],
        ),
      ],
    ),
  );
}

// Icon mood
class _MoodOption extends StatelessWidget {
  final String icon;
  final String label;

  const _MoodOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(icon, style: const TextStyle(fontSize: 22)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// =======================
//   KARTU MEDITASI
// =======================
class MeditationCard extends StatelessWidget {
  final MeditationItem item;

  const MeditationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Thumbnail kiri
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [_primaryTeal, _softPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Teks judul + info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.category} • ${item.duration}',
                  style: const TextStyle(fontSize: 13, color: _textGrey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Tombol Play
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Memulai "${item.title}"...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryTealDark,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: _primaryTealDark, width: 1.2),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }
}
