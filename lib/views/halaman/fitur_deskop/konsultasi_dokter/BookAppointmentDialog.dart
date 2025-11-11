import 'package:flutter/material.dart';
import 'package:kesehatan_ku/database/priceformat.dart';
import 'package:kesehatan_ku/models/dokter.dart';

// --- DIALOG BOOK APPOINTMENT (STATEFUL) ---

class BookAppointmentDialog extends StatefulWidget {
  // FIX: Mengganti tipe data dari 'Doctor' yang tidak terdefinisi menjadi 'DoctorModel'
  final DoctorModel doctor;
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
    '04:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi tanggal dengan hari ini
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
      cancelText: 'BATAL',
      confirmText: 'PILIH',
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
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Helper untuk menampilkan pesan kesalahan jika validasi gagal
  void _showValidationError() {
    String message = '';
    if (_selectedDate == null) {
      message = 'Mohon pilih tanggal konsultasi.';
    } else if (_selectedTimeSlot == null) {
      message = 'Mohon pilih slot waktu yang tersedia.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- FUNGSI BARU: Menampilkan dialog konfirmasi akhir ---
  Future<bool?> _showFinalConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Pemesanan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Apakah detail pemesanan Anda sudah benar?'),
                const SizedBox(height: 10),
                Text(
                  'Dokter: ${widget.doctor.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tanggal: ${_formatDate(_selectedDate!)}'),
                Text('Waktu: $_selectedTimeSlot'),
                Text('Biaya: Rp ${formatPrice(widget.doctor.price)}'),
                const SizedBox(height: 15),
                const Text(
                  'Anda akan diarahkan ke halaman pembayaran setelah konfirmasi ini.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Batal
              },
            ),
            TextButton(
              child: const Text(
                'Ya, Pesan Sekarang',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Konfirmasi
              },
            ),
          ],
        );
      },
    );
  }
  // --- AKHIR FUNGSI BARU ---

  // Saat dialog berhasil dikonfirmasi, kita pop dengan nilai 'true'
  void _confirmAndClose(BuildContext context) async {
    // Tambahkan 'async'
    // 1. Validasi Awal
    if (_selectedDate == null || _selectedTimeSlot == null) {
      _showValidationError();
      return; // Hentikan proses jika validasi gagal
    }

    // 2. Tampilkan Dialog Konfirmasi Akhir
    final bool? isConfirmed = await _showFinalConfirmationDialog();

    // 3. Proses Hasil Konfirmasi
    if (isConfirmed == true) {
      // Jika pengguna menekan 'Ya, Pesan Sekarang'
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking Confirmed with ${widget.doctor.name} on ${_formatDate(_selectedDate!)} at $_selectedTimeSlot',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      // Mengirimkan sinyal 'true' ke layar sebelumnya (menutup dialog utama)
      Navigator.of(context).pop(true);
    }
    // Jika isConfirmed == false (Batal), kita tetap di dialog booking utama.
  }

  @override
  Widget build(BuildContext context) {
    // Memeriksa apakah booking siap dikonfirmasi (untuk visualisasi tombol)
    final bool isBookingReady =
        _selectedDate != null && _selectedTimeSlot != null;

    return Dialog(
      // --- MODIFIKASI: Menjadikan latar belakang dialog transparan ---
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // -------------------------------------------------------------
      child: Container(
        // Pembungkus baru untuk konten di dalam dialog
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white, // Memberikan warna putih kembali pada konten
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            // Opsional: Tambahkan sedikit shadow pada konten
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
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
              '1. Select Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildDateSelector(context),
            const SizedBox(height: 20),

            // --- Bagian Pilih Slot Waktu ---
            const Text(
              '2. Select Time Slot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildTimeSlotSelector(),
            const SizedBox(height: 20),

            // --- Bagian Tombol Aksi ---
            Row(
              children: <Widget>[
                // Tombol Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(false), // Mengirim sinyal 'false' saat dibatalkan
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
                    // Tombol ini sekarang SELALU diaktifkan, tapi validasi ada di fungsi _confirmAndClose
                    onPressed: () => _confirmAndClose(context),
                    style: ElevatedButton.styleFrom(
                      // Visual tombol tetap terlihat bagus
                      backgroundColor: isBookingReady
                          ? Colors.blueAccent
                          : Colors.grey.shade400,
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
  Widget _buildFeeAndPointsSection(DoctorModel doctor) {
    // Menggunakan nilai price dari model sebagai fee
    // Menggunakan nilai hardcoded untuk pointsReward karena tidak ada di DoctorModel
    const int pointsReward = 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Consultation Fee'),
              Text(
                // Menggunakan fungsi pemformatan global
                'Rp ${formatPrice(doctor.price)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Points Reward'),
              // FIX: Mengganti 'doctor.pointsReward' menjadi hardcoded value
              Text(
                '+$pointsReward points',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk memilih Tanggal
  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? 'Tanggal dipilih: ${_formatDate(_selectedDate!)}'
                  : 'Ketuk untuk Pilih Tanggal',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.calendar_month, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk memilih Slot Waktu (Time Slots)
  Widget _buildTimeSlotSelector() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _timeSlots.map((slot) {
        final isSelected = _selectedTimeSlot == slot;
        return ChoiceChip(
          label: Text(slot),
          selected: isSelected,
          selectedColor: Colors.blueAccent,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? BorderSide.none
                : BorderSide(color: Colors.grey.shade300),
          ),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            setState(() {
              _selectedTimeSlot = selected ? slot : null;
            });
          },
        );
      }).toList(),
    );
  }
}
