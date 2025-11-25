import 'package:flutter/material.dart';
import 'package:kesehatan_ku/database/priceformat.dart';
import 'package:kesehatan_ku/models/doktermodel.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/konsultasi_dokter/BookAppointmentDialog.dart';

// 1. PALET WARNA UTAMA (Diambil dari main.dart)
const Color primaryAccent = Color(0xFF00A896); // Warna Aksen Utama
const Color backgroundColor = Colors.white;
const Color textColorDark = Color(0xFF1F2937);
const Color consultColor = Color(0xFF1EC0C7); // Biru Tosca untuk Konsultasi
const Color money = Colors.green;
const Color judul = Color(0xFF00A896);

// 2. UKURAN DAN DIMENSI (Diambil dari main.dart)
const double pagePadding = 16.0;
const double cardRadius = 15.0;

class DoctorListScreen extends StatelessWidget {
  final List<DoctorModel> doctors;

  const DoctorListScreen({super.key, required this.doctors});

  // Catatan: Fungsi _formatPrice telah dihapus dan diganti dengan utilitas `formatPrice`.

  // Fungsi untuk menampilkan dialog booking yang lebih lengkap
  Future<void> _showBookingDialog(
    BuildContext context,
    DoctorModel doctor,
  ) async {
    // Menampilkan BookAppointmentDialog yang lebih lengkap
    final bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BookAppointmentDialog(doctor: doctor);
      },
    );

    // Jika pengguna mengkonfirmasi booking
    if (confirmation == true) {
      _showBookingSuccess(context, doctor.name);
    }
  }

  // Fungsi untuk menampilkan pesan sukses
  void _showBookingSuccess(BuildContext context, String doctorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Booking dengan $doctorName berhasil dikonfirmasi!'),
        backgroundColor: primaryAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Konsultasi & Dokter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: judul,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(pagePadding),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return DoctorCard(
            doctor: doctor,
            onBookPressed: () => _showBookingDialog(
              context,
              doctor,
            ), // Menghubungkan tombol ke dialog baru
          );
        },
      ),
    );
  }
}

// Widget untuk menampilkan informasi dokter dalam bentuk Card
class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onBookPressed;

  // Menghapus `formatPrice` dari konstruktor karena sekarang diimpor dari utils
  const DoctorCard({
    required this.doctor,
    required this.onBookPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Gambar/Inisial Dokter
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: doctor.specialization == 'Anak'
                            ? Colors.pink.shade100
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          doctor.name[0],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Detail Dokter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColorDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialization,
                        style: TextStyle(
                          fontSize: 14,
                          color: consultColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.hospital,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            // Rating dan Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.rating} (${doctor.reviews} Review)',
                      style: const TextStyle(
                        color: textColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  // Menggunakan fungsi pemformatan global
                  'Rp ${formatPrice(doctor.price)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tombol Booking (dengan konfirmasi)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBookPressed, // Memicu dialog konfirmasi
                style: ElevatedButton.styleFrom(
                  backgroundColor: consultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Pesan Sekarang (Konsultasi)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
