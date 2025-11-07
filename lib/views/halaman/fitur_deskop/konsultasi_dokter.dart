import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/booking.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/tombolkonsultasi.dart';

// --- (TAMBAHAN SEMENTARA): MOCK UP UNTUK KONEKSI DATABASE ---
// ASUMSI: Di file Anda yang sebenarnya, Anda sudah punya DbHelper dan Model.
// Karena saya tidak bisa mengimpor, ini adalah definisi minimum yang dibutuhkan.

/// 1. ASUMSI MODEL BOOKING

/// 2. ASUMSI DB HELPER (TIRUAN)
class DbHelper {
  // Mengasumsikan fungsi createBooking berhasil
  static Future<void> createBooking(BookingModel booking) async {
    // Di sini seharusnya ada await dbs.insert(...)
    await Future.delayed(const Duration(milliseconds: 500));
    print(
      '✅ [DB MOCK] Booking berhasil dibuat untuk ${booking.doctorName} pada ${booking.dateTime}',
    );
  }
}
// --- AKHIR TAMBAHAN SEMENTARA ---

// --- 1. MODEL DATA (Doctor) ---

/// Kelas untuk merepresentasikan data seorang Dokter

// --- 2. SETUP APLIKASI UTAMA ---

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KesehatanKu App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: DoctorListScreen(doctors: dummyDoctors),
    );
  }
}

// --- 3. LAYAR DAFTAR DOKTER ---

class DoctorListScreen extends StatelessWidget {
  final List<Doctor> doctors;

  const DoctorListScreen({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konsultasi Dokter'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return DoctorCard(doctor: doctor);
        },
      ),
    );
  }
}

// Widget untuk menampilkan informasi Dokter dalam bentuk Card
class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar/Foto Dokter (Simulasi)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: Colors.lightBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctor.specialization,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '${doctor.hospital}, ${doctor.location}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      doctor.nextAvailable,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                // Tombol Book Appointment
                ElevatedButton(
                  onPressed: () {
                    // Tampilkan Dialog Booking saat tombol ditekan
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BookAppointmentDialog(doctor: doctor);
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. DIALOG BOOK APPOINTMENT (STATEFUL) ---

// Dialog ini kini menjadi Stateful agar bisa menyimpan dan mengubah tanggal yang dipilih
class BookAppointmentDialog extends StatefulWidget {
  final Doctor doctor;
  const BookAppointmentDialog({super.key, required this.doctor});

  @override
  State<BookAppointmentDialog> createState() => _BookAppointmentDialogState();
}

class _BookAppointmentDialogState extends State<BookAppointmentDialog> {
  // State untuk menyimpan tanggal yang dipilih (default: hari ini)
  DateTime? _selectedDate;
  // State untuk menyimpan slot waktu yang dipilih
  String? _selectedTimeSlot;

  // Data slot waktu dummy
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Default tanggal yang dipilih adalah hari ini
    _selectedDate = DateTime.now();
  }

  // Fungsi untuk menampilkan Kalender Picker bawaan Flutter
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      helpText: 'Pilih Tanggal Konsultasi',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Reset slot waktu saat tanggal diubah
        _selectedTimeSlot = null;
      });
    }
  }

  // Helper untuk memformat tanggal
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // 🆕 FUNGSI UNTUK MENGKONFIRMASI DAN MENYIMPAN KE DATABASE
  void _confirmBooking(BuildContext context) async {
    if (_selectedDate == null || _selectedTimeSlot == null) {
      // Seharusnya tombol sudah disabled, tapi ini sebagai fallback
      return;
    }

    final fullDateTime = '$_formatDate($_selectedDate!) $_selectedTimeSlot';

    // 1. Buat model Booking
    final newBooking = BookingModel(
      doctorName: widget.doctor.name,
      specialty: widget.doctor.specialization,
      dateTime: fullDateTime, // Gabungkan tanggal dan waktu
      price: widget.doctor.fee,
      points: widget.doctor.pointsReward,
      isActive: true, // Status default: aktif
      isCancelled: false,
      isCompleted: false,
      hasRated: false,
    );

    // 2. Simpan ke Database
    try {
      // Panggil fungsi yang ada di DbHelper Anda
      await DbHelper.createBooking(newBooking);

      // Tampilkan pesan sukses
      if (context.mounted) {
        Navigator.of(context).pop(); // Tutup dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Booking berhasil dikonfirmasi dan disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Tampilkan pesan error jika penyimpanan gagal
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Header Dialog ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Text(
              'Select date and time for your appointment with ${widget.doctor.name}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const Divider(height: 24),

            // --- Bagian Biaya dan Poin ---
            _buildFeeAndPointsSection(widget.doctor),
            const SizedBox(height: 20),

            // --- Bagian Pilih Tanggal ---
            const Text(
              'Select Date & Time',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildDateSelector(context),
            const SizedBox(height: 20),

            // --- Bagian Pilih Slot Waktu ---
            _buildTimeSlotSelector(),
            const SizedBox(height: 20),

            // --- Bagian Tombol Aksi ---
            Row(
              children: <Widget>[
                // Tombol Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                // Tombol Confirm Booking
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _selectedDate != null && _selectedTimeSlot != null
                        ? () =>
                              _confirmBooking(context) // 🔄 Panggil fungsi baru
                        : null, // Disable jika tanggal/waktu belum dipilih
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Bagian Biaya dan Poin
  Widget _buildFeeAndPointsSection(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Konsultasi Fee'),
            Text(
              'Rp ${doctor.fee.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Points Reward'),
            Text(
              '+${doctor.pointsReward} points',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper Widget untuk memilih Tanggal (Simulasi Kalender UI)
  Widget _buildDateSelector(BuildContext context) {
    // Di sini kita menggunakan tombol untuk memanggil DatePicker bawaan Flutter
    // dan menampilkan tanggal yang sudah dipilih.
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? 'Tanggal dipilih: ${_formatDate(_selectedDate!)}'
                  : 'Ketuk untuk Pilih Tanggal',
              style: TextStyle(
                color: _selectedDate != null ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.calendar_month, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk memilih Slot Waktu (Time Slots)
  Widget _buildTimeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedTimeSlot = selected ? slot : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
