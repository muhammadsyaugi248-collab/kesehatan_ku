import 'package:flutter/material.dart';

// ====== WARNA TEMA GLOBAL ======
const Color _pageBackground = Color.fromARGB(255, 201, 231, 226);
const Color _textDark = Color(0xFF1F2937);
const Color _textGrey = Color(0xFF6B7280);

// Palet untuk kebugaran (orange lembut)
const Color _workoutOrange = Color(0xFFFF8A4A);
const Color _workoutRed = Color(0xFFFF5C5C);
const Color _workoutCardBg = Color(0xFFFFF3E8);

// ====== MODEL WORKOUT SEDERHANA ======
class WorkoutProgram {
  final String title;
  final String category; // misal: "Cardio Training"
  final int durationMinutes;
  final String level; // Beginner / Intermediate / Advanced
  final String description; // optional text pendek
  final int calories; // estimasi kalori

  const WorkoutProgram({
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.level,
    required this.description,
    required this.calories,
  });
}

// Dummy data
const List<WorkoutProgram> _workouts = [
  WorkoutProgram(
    title: 'Cardio Training',
    category: 'Breathing & endurance',
    durationMinutes: 30,
    level: 'Intermediate',
    description: 'Increase your heart rate with light to moderate cardio.',
    calories: 220,
  ),
  WorkoutProgram(
    title: 'Strength Building',
    category: 'Full body workout',
    durationMinutes: 30,
    level: 'Intermediate',
    description: 'Build muscle strength using bodyweight exercises.',
    calories: 260,
  ),
  WorkoutProgram(
    title: 'Yoga Flexibility',
    category: 'Stretching & mobility',
    durationMinutes: 25,
    level: 'Beginner',
    description: 'Gentle yoga flow to improve flexibility and posture.',
    calories: 150,
  ),
];

class KebugaranScreen extends StatelessWidget {
  const KebugaranScreen({super.key});

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
              // ==== Back to dashboard ====
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

              // ==== Judul & subjudul ====
              const Text(
                'Kebugaran',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your fitness journey',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 20),

              // ==== Highlight workout plan ====
              const _WorkoutHighlightCard(),
              const SizedBox(height: 20),

              const Text(
                'Workout Programs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),

              // ==== List program kebugaran ====
              Column(
                children: _workouts
                    .map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _WorkoutProgramCard(program: w),
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

// ====== KARTU HIGHLIGHT ATAS ======
class _WorkoutHighlightCard extends StatelessWidget {
  const _WorkoutHighlightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [_workoutOrange, _workoutRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Workout Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stay active and healthy',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: Colors.white.withOpacity(0.9),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '3 workouts this week',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Icon dumbbell kanan
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// ====== KARTU PROGRAM WORKOUT ======
class _WorkoutProgramCard extends StatelessWidget {
  final WorkoutProgram program;

  const _WorkoutProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner gambar / icon
          Container(
            margin: const EdgeInsets.all(12),
            height: 90,
            decoration: BoxDecoration(
              color: _workoutCardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.fitness_center,
                size: 40,
                color: _workoutOrange,
              ),
            ),
          ),

          // Konten teks
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${program.durationMinutes} minutes • ${program.level}',
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
                const SizedBox(height: 6),
                Text(
                  program.description,
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      size: 16,
                      color: _workoutOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${program.calories} kcal',
                      style: const TextStyle(fontSize: 12, color: _textGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Tombol Start Workout
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Memulai ${program.title}...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _workoutOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Start Workout'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
