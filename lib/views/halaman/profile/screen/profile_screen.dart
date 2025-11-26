import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kesehatan_ku/models/health_datamodel.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/app_colors.dart';
import 'package:kesehatan_ku/views/halaman/profile/widgets/custom_card.dart';
import 'package:kesehatan_ku/views/halaman/profile/widgets/goals_widgets.dart';
import 'package:kesehatan_ku/views/halaman/profile/widgets/health_cards.dart';
import 'package:intl/intl.dart';

/// ---------------------------------------------------------------------------
/// METRIC PILL (kartu kecil di bawah header)
/// ---------------------------------------------------------------------------
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
              if (isChange)
                Icon(
                  detail.contains('-')
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 12,
                  color: detailColor,
                ),
              if (isChange) const SizedBox(width: 4),
              Flexible(
                child: Text(
                  detail,
                  style: TextStyle(fontSize: 11, color: detailColor),
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

/// ---------------------------------------------------------------------------
/// TAB 1 : KESEHATAN
/// ---------------------------------------------------------------------------
class HealthTab extends StatelessWidget {
  const HealthTab({super.key});

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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
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
        MedicalConditionsCard(conditions: mockConditions),
        AllergiesCard(allergies: mockAllergies),
        DoctorsRecommendationsCard(recommendations: mockRecommendations),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// TAB 2 : TARGET
/// ---------------------------------------------------------------------------
class GoalsTab extends StatelessWidget {
  const GoalsTab({super.key});

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
              ...mockGoals.map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GoalProgressCard(goal: goal),
                ),
              ),
            ],
          ),
        ),
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

/// ---------------------------------------------------------------------------
/// TAB 3 : PENGHARGAAN
/// ---------------------------------------------------------------------------
class AwardsTab extends StatelessWidget {
  const AwardsTab({super.key});

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

/// ---------------------------------------------------------------------------
/// PROFILE SCREEN (pakai data dari Firebase)
/// ---------------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = 'Teman Sehat';
  String _userEmail = '-';
  String _memberSince = '';
  bool _isLoadingHeader = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        // belum login → tetap pakai default
        setState(() {
          _userName = 'Teman Sehat';
          _userEmail = '-';
          _memberSince = '';
          _isLoadingHeader = false;
        });
        return;
      }

      String name = user.displayName ?? '';
      String email = user.email ?? '-';
      String memberSinceText = '';

      // ambil dari Firestore (users/{uid}) kalau ada
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() ?? {};
          if (data['username'] != null &&
              (data['username'] as String).isNotEmpty) {
            name = data['username'] as String;
          }

          if (data['createdAt'] != null) {
            final ts = data['createdAt'];
            DateTime created;
            if (ts is Timestamp) {
              created = ts.toDate();
            } else if (ts is DateTime) {
              created = ts;
            } else {
              created = user.metadata.creationTime ?? DateTime.now();
            }
            memberSinceText = DateFormat(
              'MMMM yyyy',
            ).format(created); // January 2024
          }
        }
      } catch (_) {
        // kalau gagal baca Firestore, fallback ke metadata auth
      }

      // fallback memberSince dari metadata kalau masih kosong
      if (memberSinceText.isEmpty && user.metadata.creationTime != null) {
        memberSinceText = DateFormat(
          'MMMM yyyy',
        ).format(user.metadata.creationTime!);
      }

      if (name.isEmpty) name = 'Teman Sehat';

      setState(() {
        _userName = name;
        _userEmail = email;
        _memberSince = memberSinceText.isNotEmpty
            ? 'Member since $memberSinceText'
            : '';
        _isLoadingHeader = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingHeader = false;
      });
    }
  }

  // Header biru dengan gradient
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // row avatar + info
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF00838F),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _isLoadingHeader
                        ? const SizedBox(
                            height: 40,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _userEmail,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (_memberSince.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _memberSince,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // tombol edit profile baris sendiri (anti overflow)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: buka halaman edit profil
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 231, 226),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 230,
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: const Color(0xFF00ACC1),
                centerTitle: false,
                title: innerBoxIsScrolled
                    ? Text(
                        _userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
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
          body: TabBarView(
            controller: _tabController,
            children: const [HealthTab(), GoalsTab(), AwardsTab()],
          ),
        ),
      ),
    );
  }
}
