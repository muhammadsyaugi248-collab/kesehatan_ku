import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 🆕 untuk tanggal
import 'package:kesehatan_ku/database/db_helper.dart'; // 🆕 untuk CRUD booking
import 'package:kesehatan_ku/models/bookingmodel.dart';
// import 'package:kesehatan_ku/models/booking_model.dart'; // 🆕 model booking

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🆕 Ganti dari dummy list ke database
  List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  // 🆕 Ambil semua booking dari SQLite
  Future<void> _loadBookings() async {
    final data = await DbHelper.getAllBookings();
    setState(() {
      _bookings = data;
    });
  }

  // 🆕 Update status booking di database
  Future<void> _updateBookingStatus(
    BookingModel booking, {
    bool? isCancelled,
    bool? hasRated,
  }) async {
    await DbHelper.updateBookingStatus(
      booking.id!,
      isCancelled: isCancelled,
      hasRated: hasRated,
    );
    await _loadBookings();
  }

  // 🆕 Hapus booking
  Future<void> _deleteBooking(BookingModel booking) async {
    await DbHelper.deleteBooking(booking.id!);
    await _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KesehatanKu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF475AD7),
        foregroundColor: Colors.white,
      ),
      body: _bookings.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pemesanan.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return _buildBookingCard(context, booking);
              },
            ),
    );
  }

  // 🧱 Kartu Booking
  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    final dateStr = DateFormat(
      'd MMM yyyy, HH:mm',
      'id_ID',
    ).format(booking.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.doctorName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            booking.specialty,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              Text(
                'Rp ${booking.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1ABC9C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                '+${booking.points} poin',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!booking.isCancelled)
                ElevatedButton(
                  onPressed: () {
                    _showCheckinDialog(context, booking);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF475AD7),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Check-in'),
                ),
              const SizedBox(width: 8),
              if (!booking.isCancelled)
                OutlinedButton(
                  onPressed: () {
                    _showCancelDialog(context, booking);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  child: const Text('Batalkan'),
                ),
              if (booking.isCancelled)
                const Text(
                  'Dibatalkan',
                  style: TextStyle(color: Colors.redAccent),
                ),
              const Spacer(),
              IconButton(
                onPressed: () => _deleteBooking(booking),
                icon: const Icon(Icons.delete, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Check-in Dialog
  void _showCheckinDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Check-in'),
        content: const Text(
          'Apakah Anda yakin ingin check-in untuk konsultasi ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showResultDialog(
                context,
                'Check-in Berhasil',
                'Anda telah melakukan check-in untuk ${booking.doctorName}.',
              );
            },
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );
  }

  // ❌ Batalkan Pemesanan
  void _showCancelDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pemesanan'),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pemesanan dengan ${booking.doctorName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _updateBookingStatus(booking, isCancelled: true);
              _showResultDialog(
                context,
                'Pemesanan Dibatalkan',
                'Pemesanan dengan ${booking.doctorName} telah dibatalkan.',
              );
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  // 🧾 Dialog hasil aksi
  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
