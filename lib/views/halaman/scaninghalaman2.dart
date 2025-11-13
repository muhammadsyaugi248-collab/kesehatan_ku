import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Definisi Model Data untuk Pemesanan
class Booking {
  final String id;
  final String service;
  final String provider; // Dokter/Lab Center
  final DateTime dateTime;
  final String location;
  final double price; // Harga ditambahkan
  final int pointsEarned; // Poin ditambahkan
  final bool isCompleted; // Status Selesai/Aktif
  final bool isCancelled; // Status Baru: Dibatalkan
  final bool hasRated; // Status Baru: Sudah memberi rating atau belum

  Booking({
    required this.id,
    required this.service,
    required this.provider,
    required this.dateTime,
    required this.location,
    required this.price,
    required this.pointsEarned,
    this.isCompleted = false,
    this.isCancelled = false,
    this.hasRated = false,
  });

  // Fungsi untuk mengembalikan Booking baru dengan status dibatalkan
  Booking copyWith({bool? isCompleted, bool? isCancelled, bool? hasRated}) {
    return Booking(
      id: id,
      service: service,
      provider: provider,
      dateTime: dateTime,
      location: location,
      price: price,
      pointsEarned: pointsEarned,
      isCompleted: isCompleted ?? this.isCompleted,
      isCancelled: isCancelled ?? this.isCancelled,
      hasRated: hasRated ?? this.hasRated,
    );
  }
}

void main() {
  // Pastikan Flutter binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  // Mengatur warna status bar dan navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Transparan agar appbar bisa custom warna
      statusBarIconBrightness: Brightness.dark, // Untuk ikon di status bar
      systemNavigationBarColor: Colors.white, // Warna navigation bar
      systemNavigationBarIconBrightness:
          Brightness.dark, // Untuk ikon di navigation bar
    ),
  );
  runApp(const scaning());
}

// Widget Utama Aplikasi
class scaning extends StatelessWidget {
  const scaning({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KesehatanKu App',
      theme: ThemeData(
        // Tema dengan warna utama ungu muda dan aksen ungu tua/biru
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
              // primaryColorDark: const Color(0xFF6B45CC), // Ungu tua
              accentColor: const Color(0xFF8E6CEF), // Ungu muda (Aksen)
            ).copyWith(
              secondary: const Color(0xFF8E6CEF), // Aksen
              primary: const Color(0xFF6B45CC), // Ungu utama
              background: const Color.fromARGB(
                255,
                201,
                231,
                226,
              ), // Latar belakang abu-abu terang
            ),
        fontFamily: 'Inter',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      home: const HomeScreen(), // Mengganti MainScreen dengan HomeScreen
    );
  }
}

// Halaman Utama yang menampilkan Scanner dan Booking List
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Contoh daftar booking (dengan status baru: cancelled, hasRated)
  List<Booking> _bookings = [
    Booking(
      id: 'BK-20251115-001',
      service: 'Konsultasi Dokter Umum',
      provider: 'Dr. Sarah Johnson',
      dateTime: DateTime(2025, 11, 15, 10, 0),
      location: 'Ruang Praktek 201',
      price: 100000.0,
      pointsEarned: 200,
      isCompleted: false, // Aktif - Belum dibatalkan
    ),
    Booking(
      id: 'BK-20251110-002',
      service: 'Tes Laboratorium',
      provider: 'Lab Center',
      dateTime: DateTime(2025, 11, 12, 8, 0),
      location: 'Laboratorium Lt. 2',
      price: 150000.0,
      pointsEarned: 300,
      isCompleted: false, // Aktif - Akan dibatalkan di demo
      isCancelled: false,
    ),
    Booking(
      id: 'BK-20251108-003', // Booking Selesai yang Belum diberi Rating
      service: 'Check-up Rutin',
      provider: 'Dr. Michael Chen',
      dateTime: DateTime(2025, 11, 8, 14, 0),
      location: 'Ruang Praktek 105',
      price: 250000.0,
      pointsEarned: 500,
      isCompleted: true, // Selesai
      hasRated: false,
    ),
    Booking(
      id: 'BK-20251101-004', // Booking Selesai dan Sudah diberi Rating
      service: 'Fisioterapi',
      provider: 'Terapis Lisa',
      dateTime: DateTime(2025, 11, 1, 16, 30),
      location: 'Pusat Rehabilitasi',
      price: 120000.0,
      pointsEarned: 240,
      isCompleted: true,
      hasRated: true,
    ),
  ];

  // State untuk melacak booking mana yang sedang "Diperiksa"
  String _checkingBookingId = '';

  // Fungsi untuk memperbarui status booking
  void _updateBookingStatus(
    Booking oldBooking, {
    bool? isCancelled,
    bool? hasRated,
  }) {
    setState(() {
      int index = _bookings.indexWhere((b) => b.id == oldBooking.id);
      if (index != -1) {
        _bookings[index] = oldBooking.copyWith(
          isCancelled: isCancelled,
          hasRated: hasRated,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('KesehatanKu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Aksi notifikasi
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'QR Code Scanner',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Scan QR code untuk check-in',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            // Bagian QR Code Scanner
            _buildQrCodeScannerCard(context),
            const SizedBox(height: 25),
            // Bagian Cara Menggunakan
            _buildHowToUseCard(context),
            const SizedBox(height: 30),
            Text(
              'Kode Booking Saya',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 15),
            // Daftar Booking
            ..._bookings
                .map(
                  (booking) => Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _buildBookingCard(context, booking),
                  ),
                )
                .toList(),
            const SizedBox(height: 40), // Spasi di bagian bawah
          ],
        ),
      ),
    );
  }

  // Widget untuk Kartu QR Code Scanner (Tidak berubah)
  Widget _buildQrCodeScannerCard(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Untuk konfirmasi booking',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              Icon(
                Icons.qr_code_2_outlined,
                color: Colors.white.withOpacity(0.7),
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15.0),
              // border: Border.all(color: Colors.white.withOpacity(0.5), width: 2, style: BorderStyle.dashed),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_2_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Arahkan kamera ke QR code',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showResultDialog(
                  context,
                  'Mulai Pemindaian',
                  'Kamera akan diaktifkan untuk memindai QR code.',
                );
              },
              icon: const Icon(Icons.camera_alt, color: Color(0xFF6B45CC)),
              label: const Text('Mulai Scan QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6B45CC),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Kartu Cara Menggunakan (Tidak berubah)
  Widget _buildHowToUseCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Cara Menggunakan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildUsagePoint('Scan QR code saat tiba di fasilitas kesehatan'),
          _buildUsagePoint('Tunjukkan kode booking kepada petugas'),
          _buildUsagePoint('QR code dapat di scan untuk konfirmasi otomatis'),
        ],
      ),
    );
  }

  Widget _buildUsagePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET UTAMA YANG DIUBAH: Kartu Booking
  Widget _buildBookingCard(BuildContext context, Booking booking) {
    // Tentukan status badge
    Color statusBgColor;
    Color statusTextColor;
    String statusText;

    if (booking.isCancelled) {
      statusText = 'Dibatalkan';
      statusBgColor = Colors.red.shade100;
      statusTextColor = Colors.red.shade700;
    } else if (booking.isCompleted) {
      statusText = 'Selesai';
      statusBgColor = Colors.grey.shade200;
      statusTextColor = Colors.grey.shade600;
    } else {
      statusText = 'Dikonfirmasi';
      statusBgColor = Colors.green.shade100;
      statusTextColor = Colors.green.shade700;
    }

    // Tentukan warna latar belakang kartu berdasarkan status (opsional)
    Color cardColor = booking.isCancelled ? Colors.red.shade50 : Colors.white;

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: booking.isCancelled
            ? BorderSide(color: Colors.red.shade300, width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.service,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              booking.provider,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 15),

            // Baris Detail Tanggal, Waktu, Lokasi & Placeholder Gambar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder Gambar
                Container(
                  width: 65,
                  height: 65,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 30,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                // Detail Tanggal, Waktu, Lokasi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        icon: Icons.calendar_today,
                        value:
                            '${booking.dateTime.day} ${getMonthName(booking.dateTime.month)}, ${booking.dateTime.year}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailItem(
                        icon: Icons.access_time,
                        value:
                            '${booking.dateTime.hour > 12 ? booking.dateTime.hour - 12 : booking.dateTime.hour}:${booking.dateTime.minute.toString().padLeft(2, '0')} ${booking.dateTime.hour < 12 ? 'AM' : 'PM'}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailItem(
                        icon: Icons.location_on_outlined,
                        value: booking.location,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            // Tambahan Poin & Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPricePointTag(
                  icon: Icons.attach_money,
                  label: 'Harga',
                  value: 'Rp ${booking.price.toStringAsFixed(0)}',
                  color: Colors.green.shade700,
                ),
                _buildPricePointTag(
                  icon: Icons.star,
                  label: 'Poin',
                  value: '+${booking.pointsEarned}',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),

            const Divider(height: 30),

            // Kode Booking dan Tombol Aksi (Diubah menjadi tumpukan vertikal)
            _buildActionSection(context, booking),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk baris detail ikon dan teks
  Widget _buildDetailItem({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  // Widget Pembantu untuk menampilkan Harga & Poin
  Widget _buildPricePointTag({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // WIDGET YANG DIUBAH: Widget Pembantu untuk tombol utama dan kode booking
  Widget _buildActionSection(BuildContext context, Booking booking) {
    Widget mainActionWidget;
    bool isChecking = _checkingBookingId == booking.id;

    if (booking.isCancelled) {
      // Dibatalkan: Hanya tampilkan status
      mainActionWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, color: Colors.red.shade800, size: 20),
            const SizedBox(width: 5),
            Text(
              'Pemesanan Dibatalkan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade800,
              ),
            ),
          ],
        ),
      );
      // Untuk status Dibatalkan, tetap tampilkan kode booking di atas
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookingIdDisplay(context, booking),
          const SizedBox(height: 15),
          mainActionWidget,
        ],
      );
    } else if (booking.isCompleted) {
      if (booking.hasRated) {
        // Selesai & Sudah Rated: Tampilkan status Review Selesai
        mainActionWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade100, // Hijau untuk Sudah Rated
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 5),
              Text(
                'Review Selesai',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        );
      } else {
        // Selesai & Belum Rated: Tampilkan tombol Beri Rating (Dibuat lebar penuh)
        mainActionWidget = SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showRatingDialog(context, booking),
            icon: const Icon(Icons.star_half, color: Colors.white, size: 20),
            label: const Text('Beri Rating Dokter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      // Tumpuk Kode Booking dan Tombol Rating/Status
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookingIdDisplay(context, booking),
          const SizedBox(height: 15),
          mainActionWidget,
        ],
      );
    } else {
      // Aktif: Tampilkan Kode Booking, Tombol Check-In, dan Batalkan (semua ditumpuk)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Kode Booking
          _buildBookingIdDisplay(context, booking),
          const SizedBox(height: 15),

          // 2. Tombol Siap Check-In / Sedang Diperiksa (Lebar Penuh)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isChecking
                  ? null
                  : () {
                      setState(() {
                        _checkingBookingId = booking.id;
                      });
                      // Simulasi proses pemeriksaan
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _checkingBookingId = '';
                          });
                          _showResultDialog(
                            context,
                            'Pemeriksaan Selesai',
                            'Data booking ${booking.id} berhasil diperiksa dan siap untuk Check-In.',
                          );
                        }
                      });
                    },
              icon: isChecking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
              label: Text(isChecking ? 'Sedang Diperiksa...' : 'Siap Check-In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ), // Dibuat lebih tinggi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 3. Tombol Batalkan Pemesanan (Lebar Penuh)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showCancelDialog(context, booking),
              icon: Icon(Icons.close, size: 18, color: Colors.red.shade600),
              label: Text(
                'Batalkan Pemesanan',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red.shade300, width: 1),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  // Widget Pembantu untuk menampilkan Kode Booking
  Widget _buildBookingIdDisplay(BuildContext context, Booking booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kode Booking',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: booking.id));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kode booking disalin!')),
            );
          },
          child: Row(
            children: [
              Text(
                booking.id,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.copy,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- LOGIKA DIALOG ---

  // Dialog untuk Konfirmasi Pembatalan
  void _showCancelDialog(BuildContext context, Booking booking) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Konfirmasi Pembatalan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // FIX OVERFLOW: Memastikan konten dapat di-scroll
          content: SingleChildScrollView(
            child: Text(
              'Apakah Anda yakin ingin membatalkan pemesanan ${booking.service} dengan ${booking.provider}?\n\n'
              'Pengembalian dana sebesar **Rp ${booking.price.toStringAsFixed(0)}** akan diproses.',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Update status booking menjadi Dibatalkan
                _updateBookingStatus(booking, isCancelled: true);
                _showResultDialog(
                  context,
                  'Pemesanan Dibatalkan!',
                  'Pemesanan ${booking.id} telah berhasil dibatalkan.\nDana akan dikembalikan dalam 1x24 jam.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk Beri Rating Dokter
  void _showRatingDialog(BuildContext context, Booking booking) {
    double selectedRating = 5.0; // Nilai default
    // String reviewText = ''; // Dihapus karena tidak digunakan di sini

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // Mendefinisikan variabel reviewText di dalam State agar TextField dapat menggunakannya
        String reviewText = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'Beri Rating untuk ${booking.provider}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // FIX OVERFLOW: Memastikan konten dialam content (Column) dapat di-scroll
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Mengatur alignment untuk tampilan yang lebih baik
                  children: [
                    Text(
                      'Layanan: ${booking.service}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Peringkat Anda (1-5):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Visual Rating Bintang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Input Komentar
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Tulis Ulasan (Opsional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        reviewText = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Nanti Saja',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Update status booking menjadi sudah dirate
                    _updateBookingStatus(booking, hasRated: true);
                    _showResultDialog(
                      context,
                      'Terima Kasih!',
                      'Rating ${selectedRating.toInt()} bintang Anda untuk ${booking.provider} telah tersimpan. Ulasan Anda:\n"$reviewText"',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kirim Rating'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Fungsi pembantu untuk mendapatkan nama bulan
  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  // Fungsi pembantu untuk menampilkan dialog (pengganti alert())
  void _showResultDialog(BuildContext context, String title, String content) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // PERBAIKAN: Menggunakan SingleChildScrollView langsung pada Text content
          content: SingleChildScrollView(child: Text(content)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF6B45CC)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
