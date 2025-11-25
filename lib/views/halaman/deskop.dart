import 'package:flutter/material.dart';
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
); // Latar Belakang Putih Bersih
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
      home: HealthHomePage(),
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
class HealthHomePage extends StatelessWidget {
  HealthHomePage({super.key});

  // ⭐ PERBAIKAN KRITIS 1: HAPUS 'const' di sini!
  // Menambahkan field 'route' untuk menunjuk ke halaman yang spesifik
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
      // Ini akan menuju ke halaman Konsultasi Dokter Anda yang di-import
      // ⭐ SOLUSI: Memanggil DoctorListScreen dengan data dummyDoctors
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
      'icon': Icons.medical_services_outlined, // Menggunakan ikon kapsul
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
    // ----------------------
  ];

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
          // Padding Halaman (Luar) = 16.0
          padding: const EdgeInsets.all(pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Bagian 1: Header Selamat Datang
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 20,
                ),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, saya sendiri! 👋',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Senin, 3 November 2025',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Spacing Antar Blok = 20.0
              const SizedBox(height: blockSpacing),

              // Bagian 2: Kartu Utama (Point Saya & Kartu Kesehatan)
              Row(
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: cardheight,
                    // Mempertahankan perubahan 'Point Saya'
                    child: SimpleCard(
                      title: 'Point Saya',
                      icon: Icons.star_border,
                      color: primaryAccent,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Point Saya diklik!')),
                      ),
                    ),
                  ),
                  // Spacing Kartu Menu = 10.0
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

              // Spacing Antar Blok = 20.0
              const SizedBox(height: blockSpacing),

              // Bagian 3: Judul Blok Modul Kesehatan
              const Text(
                'Modul Kesehatan',
                style: TextStyle(
                  // Judul Blok = 18.0, FontWeight.bold (w700)
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: textColorDark,
                ),
              ),
              const SizedBox(height: cardSpacing),

              // Bagian 4: Grid Modul Kesehatan (Menggunakan Wrap untuk responsif 2 kolom)
              Wrap(
                // Spacing Kartu Menu = 10.0
                spacing: cardSpacing,
                runSpacing: cardSpacing,
                children: menuItems.map((item) {
                  return SizedBox(
                    width: cardWidth,
                    child: MenuCard(
                      title: item['title'] as String,
                      icon: item['icon'] as IconData,
                      color: item['color'] as Color,
                      // ⭐ PERBAIKAN KRITIS 2: Ambil nilai 'route' yang unik
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
  // Tambahkan callback untuk aksi klik
  final VoidCallback onTap;

  const SimpleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap, // Inisialisasi callback
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      // Radius Kartu/Container = 15.0
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      // Gunakan InkWell untuk membuatnya bisa diklik dan memberi efek visual
      child: InkWell(
        onTap: onTap, // Menghubungkan fungsi klik
        borderRadius: BorderRadius.circular(
          cardRadius,
        ), // Radius InkWell harus sama dengan Card
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
                    // Judul Kartu = 15.0, FontWeight.w600
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
      // Radius Kartu/Container = 15.0
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      // InkWell sudah ada, ini sudah benar
      child: InkWell(
        onTap: () {
          // ⭐ PERBAIKAN KRITIS 3: Cek route sebelum navigasi
          if (route != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route!),
            );
          }
          // Aksi klik (Snackbar)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title diklik!')));
        },
        borderRadius: BorderRadius.circular(cardRadius),
        child: SizedBox(
          height: menuCardHeight, // Tinggi Kartu Menu = 120.0
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Ikon Menu di dalam latar belakang transparan
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
                // Judul Menu
                Text(
                  title,
                  style: const TextStyle(
                    // Judul Kartu = 15.0, FontWeight.w600
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
