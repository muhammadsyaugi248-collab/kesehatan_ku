// lib/views/halaman/fitur_deskop/konsultasi_dokter/tombolkonsultasi.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kesehatan_ku/models/doktermodel.dart';

// Warna-warna utama (diselaraskan dengan tema app kamu)
const Color _pageBackground = Color.fromARGB(255, 201, 231, 226);
const Color _primaryTeal = Color(0xFF00A896);
const Color _primaryTealDark = Color(0xFF028090);
const Color _textDark = Color(0xFF1F2937);
const Color _textGrey = Color(0xFF6B7280);

class DoctorListScreen extends StatelessWidget {
  final List<DoctorModel> doctors;

  const DoctorListScreen({super.key, required this.doctors});

  // ---------- HELPER: Inisial nama dokter ----------
  String _getDoctorInitials(String name) {
    if (name.trim().isEmpty) return 'DR';

    // buang "Dr", "dr", "dr." di depan kalau ada (tanpa (?i))
    final cleaned = name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim();

    final parts = cleaned.split(RegExp(r'\s+'));
    final List<String> initials = [];

    for (final p in parts) {
      if (p.isEmpty) continue;
      initials.add(p[0].toUpperCase());
      if (initials.length == 3) break; // maksimal 3 huruf
    }

    return initials.join();
  }

  // ---------- HELPER: Format Rp 150.000 ----------
  String _formatPrice(double price) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(price.round());
  }

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
              const SizedBox(height: 20),

              // ====== Title & Subtitle ======
              const Text(
                'Konsultasi & Dokter',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Book appointments with specialists',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 20),

              // ====== Telemedicine Card ======
              _buildTelemedicineCard(context),
              const SizedBox(height: 24),

              // ====== Available Doctors ======
              const Text(
                'Available Doctors',
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
                itemCount: doctors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return _buildDoctorCard(
                    context,
                    doctor: doctor,
                    initials: _getDoctorInitials(doctor.name),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== TELEMEDICINE CARD ==================
  Widget _buildTelemedicineCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [_primaryTeal, _primaryTealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryTealDark.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Text kiri
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Telemedicine',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Consult from home',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              // Icon stetoskop kanan
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Video Call belum diimplementasi.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _primaryTealDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Start Video Call'),
            ),
          ),
        ],
      ),
    );
  }

  // ================== DOCTOR CARD ==================
  Widget _buildDoctorCard(
    BuildContext context, {
    required DoctorModel doctor,
    required String initials,
  }) {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== Bagian atas: avatar, info dokter, badge status ======
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar inisial
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _pageBackground,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: _primaryTeal.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primaryTealDark.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info Dokter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialization,
                      style: const TextStyle(fontSize: 13, color: _textGrey),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: _textGrey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _textGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Badge status Available
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, size: 10, color: Color(0xFF22C55E)),
                    SizedBox(width: 4),
                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ====== Bagian bawah: harga + next available + rating & tombol ======
          // 1) Harga
          Text(
            'Rp ${_formatPrice(doctor.price)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 8),

          // 2) Next available pill (lebar mengikuti teks, tidak full card)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F0FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule, size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 6),
                Text(
                  'Next available: ${doctor.nextAvailable}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1D4ED8),
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 3) Rating + reviews (kiri) & tombol Book (kanan) -> satu baris
          Row(
            children: [
              // Rating + reviews
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 4),
                  Text(
                    doctor.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${doctor.reviewsCount} reviews)',
                    style: const TextStyle(fontSize: 11, color: _textGrey),
                  ),
                ],
              ),

              const Spacer(),

              // Tombol Book Appointment di kanan, sejajar rating
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40, maxWidth: 160),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Booking appointment dengan ${doctor.name}...',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Book Appointment'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
