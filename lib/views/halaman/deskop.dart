import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kesehatan_ku/models/doktermodel.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/konsultasi_dokter/tombolkonsultasi.dart';

// 1. PALET WARNA UTAMA (Color Palette)

const Color primaryAccent = Color(0xFF00A896); // Warna Aksen Utama/Home Icon
const Color backgroundColor = Color.fromARGB(
  255,
  201,
  231,
  226,
); // Latar Belakang
const Color textColorDark = Color(0xFF1F2937); // Hitam Gelap untuk Keterbacaan
const Color iconAqua = Color(0xFF1FB2A5); // Ikon Kesehatan Fisik
const Color iconGreen = Color(0xFF8BC34A); // Ikon Nutrisi

// --- Warna Tambahan untuk Modul Baru ---
const Color consultColor = Color(0xFF1EC0C7); // Biru Tosca untuk Konsultasi
const Color locationColor = Color(0xFF5A66F9); // Biru Ungu untuk Fasilitas
const Color historyColor = Color(0xFF6C757D); // Abu-abu gelap untuk Riwayat
const Color medicationColor = Color(0xFFF7346B); // Pink untuk Obat
const Color newsColor = Color(0xFFFF9900); // Orange untuk Berita
const Color accessibilityColor = Color(0xFF9060F7); // Ungu untuk Aksesibilitas

// 2. UKURAN DAN DIMENSI (Spacing & Radius)
const double pagePadding = 16.0;
const double blockSpacing = 20.0;
const double cardSpacing = 10.0;
const double cardRadius = 15.0; // Radius Kartu/Container
const double menuCardHeight = 120.0; // Tinggi Kartu Menu Tetap

void main() {
  runApp(const deskop());
}

class deskop extends StatelessWidget {
  const deskop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
      home: const HealthHomePage(),
    );
  }
}

// ⭐ Placeholder untuk halaman yang belum dibuat
class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: primaryAccent),
      body: Center(
        child: Text(
          'Ini adalah halaman $title',
          style: const TextStyle(fontSize: 20, color: textColorDark),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// 3. STRUKTUR HALAMAN UTAMA (Scaffold)
class HealthHomePage extends StatefulWidget {
  const HealthHomePage({super.key});

  @override
  State<HealthHomePage> createState() => _HealthHomePageState();
}

class _HealthHomePageState extends State<HealthHomePage> {
  // ------- STATE USER / SAPAAN -------
  String _userName = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Ambil nama dari FirebaseAuth (kalau ada)
  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    setState(() {
      if (user != null) {
        if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
          _userName = user.displayName!.trim();
        } else if (user.email != null && user.email!.isNotEmpty) {
          _userName = user.email!.split('@').first;
        }
      }
    });
  }

  // Sapaan dinamis (pagi / siang / sore / malam)
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'Selamat pagi';
    if (hour >= 11 && hour < 15) return 'Selamat siang';
    if (hour >= 15 && hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  // Tanggal hari ini
  String _getTodayString() {
    // Kalau mau full Indonesia pastikan intl locale sudah di-setup
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
  }

  // Inisial untuk avatar (dua huruf pertama nama)
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  // ------- DATA MENU -------
  late final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Kesehatan Fisik',
      'icon': Icons.favorite_border,
      'color': iconAqua,
      'route': const PlaceholderWidget('Kesehatan Fisik'),
    },
    {
      'title': 'Nutrisi & Pola Makan',
      'icon': Icons.apple,
      'color': iconGreen,
      'route': const PlaceholderWidget('Nutrisi & Pola Makan'),
    },
    {
      'title': 'Kebugaran',
      'icon': Icons.fitness_center,
      'color': Colors.deepOrange,
      'route': const PlaceholderWidget('Kebugaran'),
    },
    {
      'title': 'Kesehatan Mental',
      'icon': Icons.psychology_outlined,
      'color': Colors.purple,
      'route': const MentalHealthScreen(),
    },
    {
      'title': 'Konsultasi & Dokter',
      'icon': Icons.medical_services,
      'color': consultColor,
      'route': DoctorListScreen(doctors: dummyDoctors),
    },
    {
      'title': 'Fasilitas Terdekat',
      'icon': Icons.location_on_outlined,
      'color': locationColor,
      'route': const PlaceholderWidget('Fasilitas Terdekat'),
    },
    {
      'title': 'Riwayat Kesehatan',
      'icon': Icons.description_outlined,
      'color': historyColor,
      'route': const PlaceholderWidget('Riwayat Kesehatan'),
    },
    {
      'title': 'Obat & Catatan',
      'icon': Icons.medical_services_outlined,
      'color': medicationColor,
      'route': const PlaceholderWidget('Obat & Catatan'),
    },
    {
      'title': 'Berita & Edukasi',
      'icon': Icons.article_outlined,
      'color': newsColor,
      'route': const PlaceholderWidget('Berita & Edukasi'),
    },
    {
      'title': 'Aksesibilitas',
      'icon': Icons.visibility_outlined,
      'color': accessibilityColor,
      'route': const PlaceholderWidget('Aksesibilitas'),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Hitung lebar kartu menu agar pas 2 kolom
    final double availableWidth =
        MediaQuery.of(context).size.width - (2 * pagePadding);
    final double cardWidth = (availableWidth - cardSpacing) / 2;
    const double cardheight = 100;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Bagian 1: HEADER SAPAAN DINAMIS
              _buildGreetingHeader(),

              const SizedBox(height: blockSpacing),

              // Bagian 2: Kartu Utama (Point Saya & Kartu Kesehatan)
              Row(
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: cardheight,
                    child: SimpleCard(
                      title: 'Point Saya',
                      icon: Icons.star_border,
                      color: primaryAccent,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Point Saya diklik!')),
                      ),
                    ),
                  ),
                  const SizedBox(width: cardSpacing),
                  SizedBox(
                    width: cardWidth,
                    height: cardheight,
                    child: SimpleCard(
                      title: 'Kartu Kesehatan',
                      icon: Icons.credit_card,
                      color: primaryAccent,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kartu Kesehatan diklik!'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: blockSpacing),

              // Bagian 3: Judul Blok Modul Kesehatan
              const Text(
                'Modul Kesehatan',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: textColorDark,
                ),
              ),
              const SizedBox(height: cardSpacing),

              // Bagian 4: Grid Modul Kesehatan
              Wrap(
                spacing: cardSpacing,
                runSpacing: cardSpacing,
                children: menuItems.map((item) {
                  return SizedBox(
                    width: cardWidth,
                    child: MenuCard(
                      title: item['title'] as String,
                      icon: item['icon'] as IconData,
                      color: item['color'] as Color,
                      route: item['route'] as Widget?,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== HEADER WIDGET (SAPaan + TANGGAL + AVATAR) =====
  Widget _buildGreetingHeader() {
    final greeting = _getGreeting(); // Selamat pagi/siang/sore/malam
    final dateText = _getTodayString();
    final initials = _getInitials(_userName);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [iconAqua, primaryAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: primaryAccent.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Teks sapaan + tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Circle Avatar inisial user
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Text(
              initials,
              style: const TextStyle(
                color: primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Kartu Kecil di Atas (Point Saya, Kartu Kesehatan)
class SimpleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SimpleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: textColorDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk Kartu Menu Utama (Modul Kesehatan)
class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget? route;

  const MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: InkWell(
        onTap: () {
          if (route != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route!),
            );
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title diklik!')));
        },
        borderRadius: BorderRadius.circular(cardRadius),
        child: SizedBox(
          height: menuCardHeight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: textColorDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
