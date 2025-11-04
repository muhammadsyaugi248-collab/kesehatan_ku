import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Package untuk formatting tanggal

// Variabel global (tetap dipertahankan untuk kompatibilitas lingkungan Canvas)

// --- MODEL DATA (SIMULASI SKEMA DATABASE) ---

class MedicalCheck {
  final String title;
  final String latestResult;
  final String status;
  final Color statusColor;
  final IconData icon;
  final DateTime checkDate; // **BARU: Tanggal Pemeriksaan**

  MedicalCheck({
    required this.title,
    required this.latestResult,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.checkDate, // **BARU**
  });
}

// --- DATABASE HELPER (SIMULASI PENGGUNAAN DB LOKAL) ---

class DatabaseHelper {
  // Fungsi ini mensimulasikan pengambilan data dari database lokal
  // seperti SQLite (menggunakan package sqflite) secara asinkron.
  Future<List<MedicalCheck>> getMedicalChecks() async {
    // Simulasikan penundaan jaringan/disk (misalnya 1.5 detik)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Data yang diambil dari "database" (Menambahkan Tanggal Pemeriksaan)
    return [
      MedicalCheck(
        title: 'Gula Darah (Diabetes)',
        latestResult: '85 mg/dL',
        status: 'Normal',
        statusColor: Colors.green,
        icon: Icons.bloodtype,
        checkDate: DateTime(2025, 10, 28), // Tanggal baru
      ),
      MedicalCheck(
        title: 'Kolesterol Total',
        latestResult: '215 mg/dL',
        status: 'Perlu Perhatian',
        statusColor: Colors.orange,
        icon: Icons.monitor_heart,
        checkDate: DateTime(2025, 9, 15), // Tanggal baru
      ),
      MedicalCheck(
        title: 'Tekanan Darah',
        latestResult: '120/80 mmHg',
        status: 'Ideal',
        statusColor: Colors.green,
        icon: Icons.speed,
        checkDate: DateTime.now().subtract(
          const Duration(days: 2),
        ), // Tanggal 2 hari lalu
      ),
      MedicalCheck(
        title: 'Asam Urat',
        latestResult: '5.2 mg/dL',
        status: 'Normal',
        statusColor: Colors.green,
        icon: Icons.medication_liquid,
        checkDate: DateTime(2025, 10, 20), // Tanggal baru
      ),
    ];
  }
}

// --- WIDGET UTAMA (MAIN) ---

void main() {
  runApp(const healty());
}

class healty extends StatelessWidget {
  const healty({super.key});

  // Warna Primer Baru: Teal/Cyan yang cerah (seperti yang terlihat di Figma)
  static const Color primaryColor = Color(0xFF00CBA9);
  static const MaterialColor primarySwatchColor = MaterialColor(
    0xFF00CBA9,
    <int, Color>{
      50: Color(0xFFE0FFFA),
      100: Color(0xFFB3FFF5),
      200: Color(0xFF80FFF0),
      300: Color(0xFF4DFFE0),
      400: Color(0xFF26FFD0),
      500: primaryColor, // Base color
      600: Color(0xFF00B09A),
      700: Color(0xFF009684),
      800: Color(0xFF007B6F),
      900: Color(0xFF004D4B),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KesehatanKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menggunakan primary color baru
        primarySwatch: primarySwatchColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatchColor,
          accentColor: primaryColor,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F9),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const HealthyScreen(),
    );
  }
}

// --- SCREEN APLIKASI KESEHATAN (STATEFUL) ---

class HealthyScreen extends StatefulWidget {
  const HealthyScreen({super.key});

  @override
  State<HealthyScreen> createState() => _HealthyScreenState();
}

class _HealthyScreenState extends State<HealthyScreen> {
  // Warna Primer dari healty
  static const Color primaryColor = healty.primaryColor;
  static const Color secondaryTextColor = Colors.grey;
  // Warna untuk gradasi latar belakang card
  static const Color secondaryColorLight = Color(0xFF32D5B5);
  static const Color secondaryColorDark = Color(0xFF00A383);

  // State untuk data Medical Check Up
  late Future<List<MedicalCheck>> _medicalChecksFuture;

  @override
  void initState() {
    super.initState();
    // Panggil Database Helper saat widget diinisialisasi
    _medicalChecksFuture = DatabaseHelper().getMedicalChecks();
  }

  // Helper untuk mendapatkan warna teks gelap yang kontras untuk badge
  // Ini mengatasi masalah "shade()" yang tidak tersedia pada tipe Color secara statis.
  Color _getBadgeTextColor(Color baseColor) {
    // Mengecek apakah warna yang diberikan adalah MaterialColor (yang memiliki metode shade)
    if (baseColor is MaterialColor) {
      // Jika ya, gunakan shade 700 yang gelap.
      return baseColor.shade700;
    }

    // Jika itu adalah plain Color, kita mencampurnya dengan hitam
    // untuk memastikan kontras yang cukup pada badge yang transparan.
    // Faktor 0.4 membuat warna 40% lebih gelap menuju hitam.
    return Color.lerp(baseColor, Colors.black, 0.4) ?? Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Header/App Bar
      appBar: _buildAppBar(),

      // 2. Konten Utama
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Sehat Hari Ini',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937), // gray-800
              ),
            ),
            const SizedBox(height: 16),

            // Card Utama: Ringkasan Kesehatan (Detak Jantung)
            _buildSummaryCard(),

            const SizedBox(height: 24),

            const Text(
              'Progres Aktivitas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151), // gray-700
              ),
            ),
            const SizedBox(height: 12),

            // Grid Progres Harian
            _buildProgressGrid(),

            const SizedBox(height: 24),

            // Bagian Pemeriksaan Medis (Menggunakan FutureBuilder)
            _buildMedicalCheckUpSection(),

            const SizedBox(height: 24),

            // Tips Kesehatan
            _buildHealthTip(),
            const SizedBox(height: 20), // Tambahkan padding bawah
          ],
        ),
      ),
    );
  }

  // --- Implementasi Widget Pembantu ---

  // Header/Top Bar (sebagai AppBar)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1, // Sedikit bayangan
      automaticallyImplyLeading: false, // Menghilangkan tombol kembali default
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Selamat Pagi,',
                style: TextStyle(fontSize: 14, color: secondaryTextColor),
              ),
              Text(
                'ini               Budi!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          // Ikon Profil Placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor, // Menggunakan warna primer baru
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'BU',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Utama: Ringkasan Kesehatan (Detak Jantung)
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Menggunakan Gradien untuk tampilan yang lebih dinamis
        gradient: LinearGradient(
          colors: [secondaryColorLight, secondaryColorDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Detak Jantung Rata-Rata',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '72',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ' bpm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Ikon Jantung
              Icon(
                Icons.favorite,
                size: 32,
                color: Colors
                    .red[100], // Warna jantung sedikit lebih terang agar kontras
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mengubah warna Divider agar kontras dengan latar belakang hijau
          const Divider(color: Color(0xFF66E6CC), height: 1),
          const SizedBox(height: 8),
          const Text(
            'Semua parameter vital dalam batas normal.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Grid Progres Harian (Langkah, Air, Tidur, Kalori)
  Widget _buildProgressGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Menonaktifkan scroll di dalam grid
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildProgressCard(
          title: 'Langkah Hari Ini',
          value: '4.500',
          subtitle: 'dari 10.000 target',
          progressPercent: 0.45,
          progressColor: primaryColor, // Menggunakan warna primer baru
        ),
        _buildProgressCard(
          title: 'Asupan Air',
          value: '1.2 L',
          subtitle: 'Target 2.0 L',
          progressPercent: 0.60,
          progressColor: Colors.blue,
        ),
        _buildProgressCard(
          title: 'Tidur (Semalam)',
          value: '7h 30m',
          subtitle: 'Kualitas Baik',
          progressPercent: 0.90,
          progressColor: Colors.yellow,
        ),
        _buildProgressCard(
          title: 'Kalori Terbakar',
          value: '450 Kkal',
          subtitle: 'Total olahraga 30m',
          progressPercent: 0.75,
          progressColor: Colors.red,
        ),
      ],
    );
  }

  // Template untuk Card Progres
  Widget _buildProgressCard({
    required String title,
    required String value,
    required String subtitle,
    required double progressPercent,
    required Color progressColor, // Mengubah tipe menjadi Color
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            // Mengubah penggunaan shade karena progressColor sekarang bertipe Color
            style: TextStyle(
              fontSize: 11,
              color: progressColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 6),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: Colors.grey.shade200,
              color: progressColor.withOpacity(0.8),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  // Bagian Baru: Pemeriksaan Medis (Menggunakan FutureBuilder)
  Widget _buildMedicalCheckUpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasil Pemeriksaan Medis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151), // gray-700
          ),
        ),
        const SizedBox(height: 12),

        // FutureBuilder untuk memuat data dari DatabaseHelper
        FutureBuilder<List<MedicalCheck>>(
          future: _medicalChecksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Tampilkan loading indicator saat data dimuat
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              ); // Menggunakan warna primer baru
            } else if (snapshot.hasError) {
              // Tampilkan pesan error jika terjadi kesalahan
              return Center(
                child: Text('Gagal memuat data: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Tampilkan daftar data jika berhasil dimuat
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final check = snapshot.data![index];
                  return _buildCheckUpItem(
                    title: check.title,
                    latestResult: check.latestResult,
                    status: check.status,
                    statusColor: check.statusColor,
                    icon: check.icon,
                    checkDate: check.checkDate, // **BARU: Meneruskan tanggal**
                  );
                },
              );
            } else {
              // Tampilkan pesan jika data kosong
              return const Center(
                child: Text('Tidak ada data pemeriksaan medis.'),
              );
            }
          },
        ),
      ],
    );
  }

  // Template untuk Item Cek Medis
  Widget _buildCheckUpItem({
    required String title,
    required String latestResult,
    required String status,
    required Color statusColor,
    required IconData icon,
    required DateTime checkDate, // **BARU: Menerima tanggal**
  }) {
    // Format tanggal ke dalam format DD/MM/YYYY
    final formattedDate = DateFormat('dd MMMM yyyy').format(checkDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Ikon menggunakan warna primer baru
          Icon(icon, color: primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2), // Spasi kecil
                // BARU: Tampilkan Tanggal Pemeriksaan
                Text(
                  'Tanggal: $formattedDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4), // Spasi antara tanggal dan hasil

                Text(
                  'Hasil Terakhir: $latestResult',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Badge Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                // PERBAIKAN: Menggunakan helper untuk mendapatkan warna teks badge
                // yang gelap. Ini mengatasi masalah 'shade700' yang tidak tersedia
                // pada tipe 'Color' secara statis.
                color: _getBadgeTextColor(statusColor),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tips Kesehatan
  Widget _buildHealthTip() {
    // Menyesuaikan warna tips kesehatan agar lebih selaras
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(
          0xFFE0FFFA,
        ), // Warna latar belakang yang lebih terang dari palet baru
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: primaryColor, // Border menggunakan warna primer baru
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips Sehat Hari Ini',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  secondaryColorDark, // Menggunakan warna gelap dari palet baru
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pastikan Anda melakukan peregangan selama 5 menit setiap jam!',
            style: TextStyle(fontSize: 14, color: secondaryColorDark),
          ),
        ],
      ),
    );
  }
}
