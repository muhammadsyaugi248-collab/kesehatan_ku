import 'package:flutter/material.dart';

/// =================== WARNA GLOBAL ===================
const Color _pageBackground = Color.fromARGB(255, 201, 231, 226);
const Color _primaryPink = Color(0xFFFF4B8B);
const Color _primaryPinkDark = Color(0xFFEC2772);
const Color _primaryTeal = Color(0xFF00A896);
const Color _textDark = Color(0xFF1F2937);
const Color _textGrey = Color(0xFF6B7280);

/// =================== MODEL DATA SEDERHANA ===================

class Medication {
  final String name; // Metformin 500mg
  final String formAndDose; // 1 tablet
  final String frequency; // Twice daily
  final String statusLabel; // Ongoing / 3 months
  final List<String> scheduleTimes; // ['08:00 AM', '08:00 PM']
  final String instructions; // Take with meals
  final String sideEffects; // Nausea, stomach upset
  final Color statusColor; // hijau / biru dsb

  Medication({
    required this.name,
    required this.formAndDose,
    required this.frequency,
    required this.statusLabel,
    required this.scheduleTimes,
    required this.instructions,
    required this.sideEffects,
    required this.statusColor,
  });
}

class TodayScheduleItem {
  final String medName;
  final String time;
  final bool taken; // true = sudah diminum

  TodayScheduleItem({
    required this.medName,
    required this.time,
    required this.taken,
  });
}

/// =================== HALAMAN UTAMA ===================

class ObatCatatanScreen extends StatelessWidget {
  const ObatCatatanScreen({super.key});

  // Mock data obat aktif
  List<Medication> get _mockMedications => [
    Medication(
      name: 'Metformin 500mg',
      formAndDose: '1 tablet',
      frequency: 'Twice daily',
      statusLabel: 'Ongoing',
      statusColor: const Color(0xFF16A34A),
      scheduleTimes: ['08:00 AM', '08:00 PM'],
      instructions: 'Take with meals',
      sideEffects: 'Nausea, stomach upset',
    ),
    Medication(
      name: 'Atorvastatin 10mg',
      formAndDose: '1 tablet',
      frequency: 'Once daily',
      statusLabel: 'Ongoing',
      statusColor: const Color(0xFF16A34A),
      scheduleTimes: ['10:00 PM'],
      instructions: 'Take before bed',
      sideEffects: 'Muscle pain, headache',
    ),
    Medication(
      name: 'Vitamin D3',
      formAndDose: '1 capsule',
      frequency: 'Once daily',
      statusLabel: '3 months',
      statusColor: const Color(0xFF0EA5E9),
      scheduleTimes: ['09:00 AM'],
      instructions: 'Take with breakfast',
      sideEffects: 'None reported',
    ),
  ];

  // Mock data jadwal hari ini
  List<TodayScheduleItem> get _todaySchedule => [
    TodayScheduleItem(
      medName: 'Metformin 500mg',
      time: '08:00 AM',
      taken: true,
    ),
    TodayScheduleItem(medName: 'Vitamin D3', time: '09:00 AM', taken: true),
    TodayScheduleItem(
      medName: 'Metformin 500mg',
      time: '08:00 PM',
      taken: false,
    ),
    TodayScheduleItem(
      medName: 'Atorvastatin 10mg',
      time: '10:00 PM',
      taken: false,
    ),
  ];

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
              // ====== BACK TO DASHBOARD ======
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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

              // ====== TITLE ======
              const Text(
                'Obat & Catatan Dokter',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your medications',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 20),

              // ====== MEDICATION REMINDERS CARD ======
              _buildReminderCard(context),
              const SizedBox(height: 24),

              // ====== ACTIVE MEDICATIONS HEADER ======
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Active Medications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fitur tambah obat belum diimplementasi.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Medicine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ====== LIST OBAT AKTIF ======
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _mockMedications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final med = _mockMedications[index];
                  return _buildMedicationCard(med);
                },
              ),

              const SizedBox(height: 24),

              // ====== TODAY'S SCHEDULE ======
              const Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _todaySchedule.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _todaySchedule[index];
                  return _buildTodayScheduleCard(context, item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =================== REMINDER CARD ===================

  Widget _buildReminderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [_primaryPink, _primaryPinkDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryPinkDark.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul & icon lonceng
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medication Reminders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Stay on track with your meds',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Next reminder card + tombol snooze
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Ikon jam + info reminder
                Expanded(
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.alarm, color: Colors.white, size: 20),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Reminder',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Metformin 500mg at 08:00 PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Tombol Snooze
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengingat di-snooze 10 menit.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _primaryPinkDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Snooze'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =================== CARD OBAT AKTIF ===================

  Widget _buildMedicationCard(Medication med) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: icon + nama obat + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon pil
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4EC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  color: _primaryPinkDark,
                ),
              ),
              const SizedBox(width: 12),

              // Info obat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${med.formAndDose} • ${med.frequency}',
                      style: const TextStyle(fontSize: 12, color: _textGrey),
                    ),
                  ],
                ),
              ),

              // Status pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: med.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 10, color: med.statusColor),
                    const SizedBox(width: 4),
                    Text(
                      med.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: med.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Schedule
          const _SectionTitle('Schedule:'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: med.scheduleTimes
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4B5FD2),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 10),

          // Instructions
          const _SectionTitle('Instructions:'),
          const SizedBox(height: 4),
          Text(
            med.instructions,
            style: const TextStyle(fontSize: 13, color: _textDark),
          ),

          const SizedBox(height: 10),

          // Side effects
          const _SectionTitle('Side Effects:'),
          const SizedBox(height: 4),
          Text(
            med.sideEffects,
            style: const TextStyle(fontSize: 13, color: _textDark),
          ),
        ],
      ),
    );
  }

  /// =================== CARD TODAY SCHEDULE ===================

  Widget _buildTodayScheduleCard(BuildContext context, TodayScheduleItem item) {
    final Color dotColor = item.taken
        ? const Color(0xFF22C55E)
        : const Color(0xFFF97316);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // status dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),

          // nama & waktu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
              ],
            ),
          ),

          // status / tombol
          item.taken
              ? const Text(
                  '✓ Taken',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Menandai ${item.medName} jam ${item.time} sebagai sudah diminum.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Mark Taken'),
                ),
        ],
      ),
    );
  }
}

/// Judul kecil untuk bagian di dalam card (Schedule, Instructions, dll)
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 14, color: _textGrey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textGrey,
          ),
        ),
      ],
    );
  }
}
