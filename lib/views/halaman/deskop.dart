// File: lib/views/halaman/fitur_deskop/deskop.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kesehatan_ku/models/doktermodel.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/konsultasi_dokter/tombolkonsultasi.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/obat_catatan/obat_catatan_screen.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/riwayat_kesehatan/riwayat_kesehatan_screen.dart';

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

// --- Warna Tambahan untuk Modul Baru (Disesuaikan dengan Gambar) ---
const Color consultColor = Color(0xFF1EC0C7); // Biru Tosca untuk Konsultasi
const Color locationColor = Color(0xFF5A66F9); // Biru Ungu untuk Fasilitas
const Color historyColor = Color(0xFF6C757D); // Abu-abu gelap untuk Riwayat
const Color medicationColor = Color(0xFFF7346B); // Merah muda/Pink untuk Obat
const Color newsColor = Color(0xFFFF9900); // Orange untuk Berita
const Color accessibilityColor = Color(0xFF9060F7); // Ungu untuk Aksesibilitas
// -------------------------------------------------------------------

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

// ⭐ WIDGET BARU: Placeholder untuk halaman yang belum dibuat
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
  // === STATE USERNAME DARI FIREBASE ===
  String _username = 'Teman Sehat';
  bool _isLoadingName = true;

  @override
  void initState() {
    super.initState();
    _loadUsernameFromFirestore();
  }

  /// Ambil username dari Firestore: users/{uid}/username
  Future<void> _loadUsernameFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // User belum login
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _username = 'Teman Sehat';
          _isLoadingName = false;
        });
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      final data = doc.data();
      final usernameFromDb = data != null ? data['username'] as String? : null;

      setState(() {
        // Pakai field "username" yang kamu simpan di Firestore
        if (usernameFromDb != null && usernameFromDb.trim().isNotEmpty) {
          _username = usernameFromDb.trim();
        } else {
          // fallback terakhir kalau username kosong
          _username = 'Teman Sehat';
        }
        _isLoadingName = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _username = 'Teman Sehat';
        _isLoadingName = false;
      });
    }
  }

  /// Tentukan sapaan berdasarkan jam sekarang
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return 'Selamat pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  /// Format tanggal dalam bahasa Indonesia sederhana
  String _formatTodayDate() {
    final now = DateTime.now();
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final namaHari = hari[(now.weekday - 1) % 7];
    final namaBulan = bulan[(now.month - 1) % 12];

    return '$namaHari, ${now.day} $namaBulan ${now.year}';
  }

  // === MENU ITEMS (tetap seperti versi kamu) ===
  final List<Map<String, dynamic>> menuItems = [
    // Modul Lama (4)
    {
      'title': 'Kesehatan Fisik',
      'icon': Icons.favorite_border,
      'color': iconAqua, // #1FB2A5
      'route': const PlaceholderWidget('Kesehatan Fisik'), // Route 1
    },
    {
      'title': 'Nutrisi & Pola Makan',
      'icon': Icons.apple,
      'color': iconGreen, // #8BC34A
      'route': const PlaceholderWidget('Nutrisi & Pola Makan'), // Route 2
    },
    {
      'title': 'Kebugaran',
      'icon': Icons.fitness_center,
      'color': Colors.deepOrange,
      'route': const PlaceholderWidget('Kebugaran'), // Route 3
    },
    {
      'title': 'Kesehatan Mental',
      'icon': Icons.psychology_outlined,
      'color': Colors.purple,
      'route': const MentalHealthScreen(), // Route 4
    },
    // --- Modul Tambahan BARU (6) ---
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
      'route': const MedicalHistoryScreen(),
    },
    {
      'title': 'Obat & Catatan',
      'icon': Icons.medical_services_outlined,
      'color': medicationColor,
      'route': const ObatCatatanScreen(),
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

  /// Kartu sapaan di bagian paling atas
  Widget _buildGreetingCard() {
    final greeting = _getGreeting(); // Selamat pagi/siang/sore/malam
    final today = _formatTodayDate();
    final displayName = _isLoadingName
        ? '...'
        : _username; // sementara "..." saat loading

    // ambil inisial untuk avatar
    String initials = 'U';
    if (displayName.trim().isNotEmpty && displayName != '...') {
      final parts = displayName.trim().split(' ');
      if (parts.length == 1) {
        initials = parts.first.characters.first.toUpperCase();
      } else {
        initials = (parts[0].characters.first + parts[1].characters.first)
            .toUpperCase();
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        gradient: const LinearGradient(
          colors: [iconAqua, primaryAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryAccent.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Teks sapaan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris: "Selamat pagi, Asep! 👋"
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '$greeting, $displayName!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('👋', style: TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  today,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Circle Avatar dengan inisial
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryAccent.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung lebar kartu menu agar benar-benar pas 2 kolom
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
              // Bagian 1: Header Sapaan Dinamis
              _buildGreetingCard(),

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
