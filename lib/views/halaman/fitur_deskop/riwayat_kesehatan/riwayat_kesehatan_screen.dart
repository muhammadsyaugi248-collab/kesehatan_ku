import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/riwayat_kesehatan/models/riwayatmodels.dart';

/// =======================
/// HALAMAN RIWAYAT KESEHATAN
/// =======================

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  // Warna selaras dengan halaman lain
  static const Color _pageBackground = Color.fromARGB(255, 201, 231, 226);
  static const Color _textDark = Color(0xFF1F2937);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _cardBorder = Color(0xFFE5E7EB);

  // Data dummy (bisa diganti dengan data dari backend)
  List<CheckupRecord> get _mockRecords => [
    CheckupRecord(
      title: 'Check-up Rutin',
      date: DateTime(2025, 11, 10),
      doctorName: 'Dr. Sarah Johnson',
      summary: 'Routine health check – All normal',
      isNormal: true,
      diagnoses: const [],
      medications: const [],
      advices: const [
        'Pertahankan pola makan seimbang',
        'Lanjutkan aktivitas fisik 3–4x seminggu',
      ],
    ),
    CheckupRecord(
      title: 'Kontrol Tekanan Darah',
      date: DateTime(2025, 9, 22),
      doctorName: 'Dr. Michael Chen',
      summary: 'Tekanan darah agak tinggi, perlu pemantauan.',
      isNormal: false,
      diagnoses: const [
        Diagnosis(name: 'Hipertensi Derajat 1', isChronic: true),
        Diagnosis(name: 'Kadar kolesterol borderline'),
      ],
      medications: const [
        Medication(
          name: 'Amlodipine 5 mg',
          dosage: '1 tablet',
          frequency: '1x sehari malam hari',
        ),
        Medication(
          name: 'Simvastatin 10 mg',
          dosage: '1 tablet',
          frequency: '1x sehari sebelum tidur',
        ),
      ],
      advices: const [
        'Kurangi makanan berminyak dan gorengan',
        'Batasi konsumsi garam (maks 1 sendok teh per hari)',
        'Perbanyak sayur, buah, dan air putih',
        'Olahraga ringan minimal 30 menit per hari',
      ],
    ),
    CheckupRecord(
      title: 'Pemeriksaan Gula Darah',
      date: DateTime(2025, 7, 5),
      doctorName: 'Dr. Lisa Putri',
      summary: 'Gula darah puasa sedikit di atas normal.',
      isNormal: false,
      diagnoses: const [Diagnosis(name: 'Prediabetes')],
      medications: const [
        Medication(
          name: 'Metformin 500 mg',
          dosage: '1 tablet',
          frequency: '2x sehari setelah makan',
        ),
      ],
      advices: const [
        'Hindari minuman manis dan makanan tinggi gula',
        'Jaga berat badan ideal',
        'Kontrol ulang 3 bulan ke depan',
      ],
    ),
  ];

  String _formatDate(DateTime date) {
    // Format sederhana: "Nov 10, 2025"
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = months[date.month - 1];
    return '$m ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final records = _mockRecords;

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Back to Dashboard =====
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back, size: 26, color: _textDark),
                      SizedBox(width: 8),
                      Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== Title & subtitle =====
              const Text(
                'Riwayat Kesehatan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your medical history',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 20),

              // ===== Medical Records big card =====
              _buildMedicalRecordsCard(context),
              const SizedBox(height: 20),

              // ===== List Check-up =====
              for (final record in records) ...[
                _buildCheckupCard(context, record),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalRecordsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF4B5563),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Records',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete health history',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckupCard(BuildContext context, CheckupRecord record) {
    final badgeColor = record.isNormal
        ? const Color(0xFFE6F9EE)
        : const Color(0xFFFFF3F0);
    final badgeTextColor = record.isNormal
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);
    final badgeLabel = record.isNormal ? 'Normal' : 'Perlu perhatian';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul & badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      record.isNormal
                          ? Icons.check_circle
                          : Icons.warning_amber,
                      size: 14,
                      color: badgeTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      badgeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Tanggal & dokter
          Text(
            '${_formatDate(record.date)} • ${record.doctorName}',
            style: const TextStyle(fontSize: 12, color: _textGrey),
          ),
          const SizedBox(height: 6),

          // Summary
          Text(
            record.summary,
            style: const TextStyle(fontSize: 13, color: _textDark),
          ),
          const SizedBox(height: 10),

          if (record.diagnoses.isNotEmpty) ...[
            const Text(
              'Diagnosis',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: record.diagnoses.map((d) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: d.isChronic
                        ? const Color(0xFFFFE4E6)
                        : const Color(0xFFE5F3FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        d.isChronic
                            ? Icons.health_and_safety
                            : Icons.info_outline,
                        size: 14,
                        color: d.isChronic
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        d.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: d.isChronic
                              ? const Color(0xFF991B1B)
                              : const Color(0xFF1D4ED8),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],

          if (record.medications.isNotEmpty) ...[
            const Text(
              'Obat & Aturan Minum',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: record.medications.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.medication_outlined,
                        size: 16,
                        color: Color(0xFF0EA5E9),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: _textDark,
                            ),
                            children: [
                              TextSpan(
                                text: '${m.name} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '– ${m.dosage}, ${m.frequency}', // aturan minum
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],

          if (record.advices.isNotEmpty) ...[
            const Text(
              'Anjuran Penjagaan Kesehatan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: record.advices.map((a) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(fontSize: 12, color: _textGrey),
                      ),
                      Expanded(
                        child: Text(
                          a,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
