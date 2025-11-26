import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

// --- MODEL DATA (SIMULASI SKEMA DATABASE) ---

class MedicalCheck {
  final String title;
  final String latestResult;
  final String status;
  final Color statusColor;
  final IconData icon;
  final DateTime checkDate;

  MedicalCheck({
    required this.title,
    required this.latestResult,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.checkDate,
  });
}

// --- DATABASE HELPER (SIMULASI DB LOKAL) ---

class DatabaseHelper {
  Future<List<MedicalCheck>> getMedicalChecks() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    return [
      MedicalCheck(
        title: 'Gula Darah (Diabetes)',
        latestResult: '85 mg/dL',
        status: 'Normal',
        statusColor: Colors.green,
        icon: Icons.bloodtype,
        checkDate: DateTime(2025, 10, 28),
      ),
      MedicalCheck(
        title: 'Kolesterol Total',
        latestResult: '215 mg/dL',
        status: 'Perlu Perhatian',
        statusColor: Colors.orange,
        icon: Icons.monitor_heart,
        checkDate: DateTime(2025, 9, 15),
      ),
      MedicalCheck(
        title: 'Tekanan Darah',
        latestResult: '120/80 mmHg',
        status: 'Ideal',
        statusColor: Colors.green,
        icon: Icons.speed,
        checkDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      MedicalCheck(
        title: 'Asam Urat',
        latestResult: '5.2 mg/dL',
        status: 'Normal',
        statusColor: Colors.green,
        icon: Icons.medication_liquid,
        checkDate: DateTime(2025, 10, 20),
      ),
    ];
  }
}

// --- APP DEMO (BOLEH DIABAIKAN JIKA PAKAI BOTTOM NAV DI MAIN DART) ---

void main() {
  runApp(const healty());
}

class healty extends StatelessWidget {
  const healty({super.key});

  // Warna Primer
  static const Color primaryColor = Color(0xFF00CBA9);
  static const MaterialColor primarySwatchColor =
      MaterialColor(0xFF00CBA9, <int, Color>{
        50: Color(0xFFE0FFFA),
        100: Color(0xFFB3FFF5),
        200: Color(0xFF80FFF0),
        300: Color(0xFF4DFFE0),
        400: Color(0xFF26FFD0),
        500: primaryColor,
        600: Color(0xFF00B09A),
        700: Color(0xFF009684),
        800: Color(0xFF007B6F),
        900: Color(0xFF004D4B),
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KesehatanKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatchColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatchColor,
          accentColor: primaryColor,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          201,
          231,
          226,
        ), // hijau muda
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const HealthyScreen(),
    );
  }
}

// --- SCREEN APLIKASI KESEHATAN ---

class HealthyScreen extends StatefulWidget {
  const HealthyScreen({super.key});

  @override
  State<HealthyScreen> createState() => _HealthyScreenState();
}

class _HealthyScreenState extends State<HealthyScreen> {
  static const Color primaryColor = healty.primaryColor;
  static const Color secondaryTextColor = Colors.grey;

  // Warna gradasi ringkasan
  static const Color secondaryColorLight = Color(0xFF32D5B5);
  static const Color secondaryColorDark = Color(0xFF00A383);

  late Future<List<MedicalCheck>> _medicalChecksFuture;

  @override
  void initState() {
    super.initState();
    _medicalChecksFuture = DatabaseHelper().getMedicalChecks();
  }

  Color _getBadgeTextColor(Color baseColor) {
    if (baseColor is MaterialColor) {
      return baseColor.shade700;
    }
    return Color.lerp(baseColor, Colors.black, 0.4) ?? Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TIDAK ADA APPBAR DI SINI
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LANGSUNG KE KONTEN UTAMA
              const Text(
                'Status Sehat Hari Ini',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),

              _buildSummaryCard(),
              const SizedBox(height: 24),

              const Text(
                'Progres Aktivitas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 12),

              _buildProgressGrid(),
              const SizedBox(height: 24),

              _buildMedicalCheckUpSection(),
              const SizedBox(height: 24),

              _buildHealthTip(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- CARD RINGKASAN DETAK JANTUNG ---

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
              Icon(Icons.favorite, size: 32, color: Colors.redAccent.shade100),
            ],
          ),
          const SizedBox(height: 16),
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

  // --- GRID PROGRES HARIAN ---

  Widget _buildProgressGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildProgressCard(
          title: 'Langkah Hari Ini',
          value: '4.500',
          subtitle: 'dari 10.000 target',
          progressPercent: 0.45,
          progressColor: primaryColor,
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
          progressColor: Colors.yellow.shade700,
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

  Widget _buildProgressCard({
    required String title,
    required String value,
    required String subtitle,
    required double progressPercent,
    required Color progressColor,
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
            style: TextStyle(
              fontSize: 11,
              color: progressColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 6),
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

  // --- BAGIAN PEMERIKSAAN MEDIS ---

  Widget _buildMedicalCheckUpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasil Pemeriksaan Medis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<MedicalCheck>>(
          future: _medicalChecksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Gagal memuat data: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                    checkDate: check.checkDate,
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Tidak ada data pemeriksaan medis.'),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCheckUpItem({
    required String title,
    required String latestResult,
    required String status,
    required Color statusColor,
    required IconData icon,
    required DateTime checkDate,
  }) {
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
                const SizedBox(height: 2),
                Text(
                  'Tanggal: $formattedDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hasil Terakhir: $latestResult',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
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

  // --- TIPS KESEHATAN ---

  Widget _buildHealthTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0FFFA),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: primaryColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips Sehat Hari Ini',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: secondaryColorDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pastikan Anda melakukan peregangan selama 5 menit setiap jam!',
            style: const TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
