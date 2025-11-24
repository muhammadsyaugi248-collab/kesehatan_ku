import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/health_data.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/app_colors.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/widgets/custom_card.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/widgets/goals_widgets.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/widgets/health_cards.dart';
// Mengimpor cards utama

// === Data Header Mock ===
const String mockUserName = 'Ahmad Ridwan';
const String mockUserEmail = 'ahmad.ridwan@example.com';
const String mockMemberSince = 'January 2024';

// Widget kartu kecil di bawah header (Checkups, Heart Rate, dll.)
class MetricPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String detail;
  final Color detailColor;

  const MetricPill({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.detail,
    required this.detailColor,
  });

  @override
  Widget build(BuildContext context) {
    // Logika untuk menentukan apakah detail adalah perubahan numerik (+/-)
    final bool isChange = detail.startsWith('+') || detail.startsWith('-');

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hanya tampilkan ikon jika itu adalah perubahan numerik
              if (isChange)
                Icon(
                  detail.contains('-')
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 12,
                  color: detailColor,
                ),
              if (isChange) const SizedBox(width: 4),

              // Menggunakan Flexible untuk mencegah overflow pada teks detail
              Flexible(
                child: Text(
                  detail,
                  style: TextStyle(fontSize: 11, color: detailColor),
                  // Pastikan teks dapat dipotong dengan elipsis jika masih terlalu panjang
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// === Tab Kesehatan (Health Tab) ===
class HealthTab extends StatelessWidget {
  const HealthTab({super.key});

  // Mock Data
  final List<MedicalCondition> mockConditions = const [
    MedicalCondition(id: 'c1', name: 'Hipertensi Ringan', severity: 'Ringan'),
    MedicalCondition(
      id: 'c2',
      name: 'Defisiensi Vitamin D',
      severity: 'Sedang',
    ),
  ];
  final List<Allergy> mockAllergies = const [
    Allergy(name: 'Kacang-kacangan', type: 'Makanan'),
    Allergy(name: 'Penisilin', type: 'Obat'),
    Allergy(name: 'Tungau Debu', type: 'Lingkungan'),
  ];
  final List<Recommendation> mockRecommendations = const [
    Recommendation(text: 'Pantau tekanan darah secara teratur'),
    Recommendation(text: 'Diet rendah natrium'),
    Recommendation(text: 'Jalan kaki 30 menit setiap hari'),
  ];

  @override
  Widget build(BuildContext context) {
    // Memanggil widget Health Cards dengan data mock
    return ListView(
      // Penting: Hapus padding bawaan ListView karena sudah ada di CustomScrollView
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Kartu Metric Tambahan (Hanya di tab Info/Kesehatan) ---
        CustomCard(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MetricPill(
                icon: Icons.monitor_heart_outlined,
                iconColor: Colors.blue.shade600,
                title: 'Checkups',
                value: '12',
                detail: '-2 this month',
                detailColor: Colors.green.shade600,
              ),
              MetricPill(
                icon: Icons.favorite,
                iconColor: Colors.red.shade600,
                title: 'Heart Rate',
                value: '72 bpm',
                detail: 'Normal',
                detailColor: Colors.green.shade600,
              ),
              MetricPill(
                icon: Icons.mode_night,
                iconColor: Colors.deepPurple.shade600,
                title: 'Sleep',
                value: '7.5h',
                detail: '-0.5h from last week',
                detailColor: Colors.red.shade600,
              ),
              MetricPill(
                icon: Icons.directions_run_outlined,
                iconColor: Colors.orange.shade600,
                title: 'Steps Today',
                value: '8,234',
                detail: 'Goal: 10,000',
                detailColor: Colors.orange.shade600,
              ),
            ],
          ),
        ),
        // --- Kartu Informasi Kesehatan Bawah ---
        MedicalConditionsCard(conditions: mockConditions),
        AllergiesCard(allergies: mockAllergies),
        DoctorsRecommendationsCard(recommendations: mockRecommendations),
      ],
    );
  }
}

// === Tab Target (Goals Tab) ===
class GoalsTab extends StatelessWidget {
  const GoalsTab({super.key});

  // Mock Data untuk GoalsTab
  final List<Goal> mockGoals = const [
    Goal(
      title: 'Target Penurunan Berat Badan',
      current: 78,
      target: 75,
      unit: 'kg',
    ),
    Goal(title: 'Asupan Air Harian', current: 2.5, target: 3.0, unit: 'L'),
    Goal(title: 'Rata-rata Jam Tidur', current: 6.8, target: 7.5, unit: 'jam'),
    Goal(
      title: 'Waktu Olahraga Mingguan',
      current: 180,
      target: 200,
      unit: 'menit',
    ),
  ];

  final List<VitalsComparison> mockVitals = const [
    VitalsComparison(
      label: 'Berat Badan',
      value: '78 kg',
      change: '-1.5',
      icon: Icons.scale_outlined,
    ),
    VitalsComparison(
      label: 'IMT',
      value: '25.3',
      change: '-0.4',
      icon: Icons.straighten,
    ),
    VitalsComparison(
      label: 'Detak Jantung (Istirahat)',
      value: '62 bpm',
      change: 'Stabil',
      icon: Icons.favorite_border,
    ),
    VitalsComparison(
      label: 'Tekanan Darah',
      value: '135/85 mmHg',
      change: '+3',
      icon: Icons.monitor_heart_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Kartu Progress Tujuan
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progres Target Kesehatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 15),
              ...mockGoals
                  .map(
                    (goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GoalProgressCard(goal: goal),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),

        // Kartu Perbandingan Vital
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perbandingan Vital (vs. Bulan Lalu)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 15),
              ...mockVitals
                  .map((vitals) => ComparisonRow(comparison: vitals))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }
}

// === Tab Penghargaan (Awards Tab) ===
class AwardsTab extends StatelessWidget {
  const AwardsTab({super.key});

  // Mock Data untuk AwardsTab
  final List<Award> mockAwards = const [
    Award(
      icon: Icons.run_circle_outlined,
      title: 'Pelari Marathon',
      color: Color.fromARGB(255, 237, 246, 255),
      iconColor: Color.fromARGB(255, 66, 133, 244),
    ),
    Award(
      icon: Icons.access_time_filled,
      title: 'Tidur Konsisten',
      color: Color.fromARGB(255, 237, 255, 237),
      iconColor: Color.fromARGB(255, 52, 168, 83),
    ),
    Award(
      icon: Icons.water_drop_outlined,
      title: 'Master Hidrasi',
      color: Color.fromARGB(255, 246, 237, 255),
      iconColor: Color.fromARGB(255, 150, 47, 219),
    ),
    Award(
      icon: Icons.directions_walk_outlined,
      title: 'Pejalan Kaki Harian',
      color: Color.fromARGB(255, 255, 245, 237),
      iconColor: Color.fromARGB(255, 251, 140, 0),
    ),
    Award(
      icon: Icons.fitness_center_outlined,
      title: 'Rajin Latihan',
      color: Color.fromARGB(255, 255, 237, 245),
      iconColor: Color.fromARGB(255, 219, 47, 150),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prestasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),
          // Menggunakan Expanded agar GridView mengisi ruang yang tersisa
          Expanded(
            child: GridView.builder(
              itemCount: mockAwards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return AwardTile(award: mockAwards[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// === Layar Utama Dashboard (Diperbarui dengan NestedScrollView) ===
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Widget Header Kustom (Area di atas tab bar)
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient:
            headerGradient, // Menggunakan gradient kustom dari app_colors.dart
      ),
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Area Info Profil
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Profil
                const CircleAvatar(
                  radius: 35,
                  // Gambar placeholder hanya untuk representasi
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF00838F)),
                ),
                const SizedBox(width: 16),
                // Nama & Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        mockUserName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        mockUserEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Member since $mockMemberSince',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tombol Edit Profile
                OutlinedButton.icon(
                  onPressed: () {
                    // Implementasi logika edit
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3, // Sama dengan jumlah Tab
        child: NestedScrollView(
          // Header yang bisa diciutkan
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // Title (Dihapus karena akan menyebabkan tumpang tindih dengan FlexibleSpaceBar)
                title: null, // Mengganti logika title yang kompleks dengan null

                centerTitle: false, // Menjaga judul tetap di kiri
                // Mengatur automaticallyImplyLeading ke false memastikan tidak ada tombol kembali default
                automaticallyImplyLeading: false,
                // Ganti warna saat ciut agar sesuai dengan gradient header (teal yang lebih terang)
                backgroundColor: const Color(
                  0xFF00ACC1,
                ), // customPrimaryColor[600]
                expandedHeight: 220.0, // Ketinggian saat Header penuh
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  // Menggunakan FlexibleSpaceBar.title untuk menampilkan nama saat diciutkan
                  title: innerBoxIsScrolled
                      ? Text(
                          mockUserName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      : null, // Title di FlexibleSpaceBar disembunyikan saat diperluas (tidak perlu, karena sudah di background)
                  // Content saat Header penuh (foto, nama, dll.)
                  background: _buildProfileHeader(context),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(icon: Icon(Icons.favorite), text: 'Kesehatan'),
                    Tab(icon: Icon(Icons.trending_up), text: 'Target'),
                    Tab(icon: Icon(Icons.military_tech), text: 'Penghargaan'),
                  ],
                ),
              ),
            ];
          },
          // Isi Tab View
          body: TabBarView(
            controller: _tabController,
            children: const [HealthTab(), GoalsTab(), AwardsTab()],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 201, 231, 226),
    );
  }
}
