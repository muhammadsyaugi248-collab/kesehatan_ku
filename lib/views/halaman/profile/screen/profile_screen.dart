// lib/views/halaman/profile/profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/health_stats.dart';
import 'package:kesehatan_ku/views/halaman/profile/screen/edit_profile_screen.dart';

/// ================== WARNA & GRADIENT ==================

const Color kProfileBg = Color.fromARGB(255, 201, 231, 226);
const Color kPrimaryTeal = Color(0xFF00A896);
const Color kPrimaryTealDark = Color(0xFF028090);
const Color kTextDark = Color(0xFF1F2937);
const Color kTextGrey = Color(0xFF6B7280);

const LinearGradient headerGradient = LinearGradient(
  colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Indikator naik / turun / perlu perhatian
Color trendColor(String change) {
  final text = change.trim().toLowerCase();

  if (text.startsWith('+')) {
    return Colors.green.shade600; // naik
  }
  if (text.startsWith('-')) {
    return Colors.red.shade600; // turun
  }
  if (text.contains('perhatian') ||
      text.contains('waspada') ||
      text.contains('high') ||
      text.contains('tinggi')) {
    return Colors.orange.shade700; // perlu perhatian
  }
  return kTextGrey;
}

/// ================== UTIL: LOADING DIALOG ==================

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        const Center(child: CircularProgressIndicator(strokeWidth: 4)),
  );
}

void hideLoadingDialog(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}

/// Helper status – cuma buat tampilan, bukan diagnosis medis.
String classifyTotalCholesterol(double total) {
  if (total <= 0) return 'Tidak ada data';
  if (total < 200) return 'Baik';
  if (total < 240) return 'Perlu perhatian';
  return 'Tinggi';
}

String classifyGlucose(double g) {
  if (g <= 0) return 'Tidak ada data';
  if (g < 100) return 'Normal';
  if (g < 126) return 'Perlu perhatian';
  return 'Tinggi';
}

String classifyBloodPressure(int sys, int dia) {
  if (sys == 0 || dia == 0) return 'Tidak ada data';
  if (sys < 120 && dia < 80) return 'Normal';
  if (sys < 140 && dia < 90) return 'Perlu perhatian';
  return 'Tinggi';
}

String classifyUricAcid(double u) {
  if (u <= 0) return 'Tidak ada data';
  if (u <= 7.0) return 'Normal';
  return 'Tinggi';
}

Color statusColor(String status) {
  final s = status.toLowerCase();
  if (s.contains('baik') || s.contains('normal')) {
    return Colors.green.shade600;
  }
  if (s.contains('perhatian')) {
    return Colors.orange.shade700;
  }
  if (s.contains('tinggi')) {
    return Colors.red.shade600;
  }
  return kTextGrey;
}

/// ================== PROFILE SCREEN ==================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  User? _firebaseUser;
  DocumentSnapshot<Map<String, dynamic>>? _userDoc;
  bool _loadingProfile = true;

  HealthStats? _healthStats;
  bool _vitalsUpdatedByUser = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loadingProfile = true);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _firebaseUser = null;
        _userDoc = null;
        _healthStats = null;
        _vitalsUpdatedByUser = false;
        _loadingProfile = false;
      });
      return;
    }

    // ---- ambil dokumen user dari Firestore ----
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data();
    HealthStats? stats;
    bool updatedFlag = false;

    if (data != null) {
      final healthMap = data['healthStats'];
      if (healthMap is Map<String, dynamic>) {
        stats = HealthStats.fromMap(healthMap);
      }
      updatedFlag = (data['vitalsUpdatedByUser'] ?? false) as bool;
    }

    setState(() {
      _firebaseUser = user;
      _userDoc = doc;
      _healthStats = stats;
      _vitalsUpdatedByUser = updatedFlag;
      _loadingProfile = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _memberSinceText() {
    final user = _firebaseUser;
    if (user?.metadata.creationTime == null) return 'Member';

    final dt = user!.metadata.creationTime!;
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return 'Member since ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _buildProfileHeader(BuildContext context) {
    final data = _userDoc?.data() ?? {};
    final username =
        (data['username'] as String?) ??
        _firebaseUser?.displayName ??
        'Pengguna';
    final email =
        (data['email'] as String?) ??
        _firebaseUser?.email ??
        'email@contoh.com';
    final photoUrl = (data['photoUrl'] as String?) ?? _firebaseUser?.photoURL;

    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';

    ImageProvider? avatarImage;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      avatarImage = NetworkImage(photoUrl);
    }

    return Container(
      decoration: const BoxDecoration(gradient: headerGradient),
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info profil
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto profil – sedikit turun biar sejajar teks
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: avatarImage,
                    child: avatarImage == null
                        ? Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00838F),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Nama & email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 14,
                            color: Colors.white.withOpacity(0.85),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _memberSinceText(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol Edit Profile – tetap di atas
                Padding(
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final changed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            initialUsername: username,
                            initialEmail: email,
                            initialPhotoUrl: photoUrl,
                            initialHealthStats: _healthStats,
                          ),
                        ),
                      );

                      if (changed == true && mounted) {
                        _loadProfile(); // refresh data
                      }
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
      backgroundColor: kProfileBg,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: null,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF00ACC1),
                expandedHeight: 220,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  title: innerBoxIsScrolled && !_loadingProfile
                      ? Text(
                          (_userDoc?.data()?['username'] as String?) ??
                              _firebaseUser?.displayName ??
                              'Pengguna',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      : null,
                  background: _loadingProfile
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : _buildProfileHeader(context),
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
            children: [
              HealthTab(
                healthStats: _healthStats,
                vitalsUpdatedByUser: _vitalsUpdatedByUser,
              ),
              GoalsTab(healthStats: _healthStats),
              const AwardsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================== SMALL CARD WIDGET ==================

class ProfileCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ProfileCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ================== TAB 1: KESEHATAN ==================

class HealthTab extends StatelessWidget {
  final HealthStats? healthStats;
  final bool vitalsUpdatedByUser;

  const HealthTab({
    super.key,
    this.healthStats,
    required this.vitalsUpdatedByUser,
  });

  @override
  Widget build(BuildContext context) {
    final conditions = [
      {'name': 'Hipertensi Ringan', 'severity': 'Ringan'},
      {'name': 'Defisiensi Vitamin D', 'severity': 'Sedang'},
    ];

    final allergies = [
      {'name': 'Kacang-kacangan', 'type': 'Makanan'},
      {'name': 'Penisilin', 'type': 'Obat'},
      {'name': 'Tungau Debu', 'type': 'Lingkungan'},
    ];

    final recommendations = [
      'Pantau tekanan darah secara teratur',
      'Diet rendah natrium',
      'Jalan kaki 30 menit setiap hari',
    ];

    final hs = healthStats;

    String cholStatus = 'Tidak ada data';
    String glucoseStatus = 'Tidak ada data';
    String bpStatus = 'Tidak ada data';
    String uricStatus = 'Tidak ada data';

    if (hs != null) {
      cholStatus = classifyTotalCholesterol(hs.totalCholesterol);
      glucoseStatus = classifyGlucose(hs.glucose);
      bpStatus = classifyBloodPressure(hs.systolic, hs.diastolic);
      uricStatus = classifyUricAcid(hs.uricAcid);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (hs != null)
          ProfileCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Hasil Pemeriksaan Terakhir',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (vitalsUpdatedByUser)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'User input',
                          style: TextStyle(
                            fontSize: 11,
                            color: kPrimaryTealDark,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _ResultRow(
                  label: 'Total Kolesterol',
                  value: hs.totalCholesterol == 0
                      ? '-'
                      : '${hs.totalCholesterol.toStringAsFixed(0)} mg/dL',
                  status: cholStatus,
                ),
                _ResultRow(
                  label: 'Gula Darah',
                  value: hs.glucose == 0
                      ? '-'
                      : '${hs.glucose.toStringAsFixed(0)} mg/dL',
                  status: glucoseStatus,
                ),
                _ResultRow(
                  label: 'Tekanan Darah',
                  value: (hs.systolic == 0 || hs.diastolic == 0)
                      ? '-'
                      : '${hs.systolic}/${hs.diastolic} mmHg',
                  status: bpStatus,
                ),
                _ResultRow(
                  label: 'Asam Urat',
                  value: hs.uricAcid == 0
                      ? '-'
                      : '${hs.uricAcid.toStringAsFixed(1)} mg/dL',
                  status: uricStatus,
                ),
              ],
            ),
          ),

        // Metric row (dummy, bisa dihubungkan ke data lain)
        ProfileCard(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              MetricPill(
                icon: Icons.monitor_heart_outlined,
                title: 'Checkups',
                value: '12',
                detail: '+2 tahun ini',
              ),
              MetricPill(
                icon: Icons.favorite,
                title: 'Heart Rate',
                value: '72 bpm',
                detail: 'Normal',
              ),
              MetricPill(
                icon: Icons.mode_night,
                title: 'Sleep',
                value: '7.5h',
                detail: '-0.5h week',
              ),
              MetricPill(
                icon: Icons.directions_run_outlined,
                title: 'Steps',
                value: '8.234',
                detail: '+1.200',
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Kondisi medis
        ProfileCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kondisi Medis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 8),
              ...conditions.map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: kPrimaryTeal,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c['name']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: kTextDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          c['severity']!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: kPrimaryTealDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Alergi
        ProfileCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alergi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 8),
              ...allergies.map(
                (a) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_outlined,
                        size: 18,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a['name']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: kTextDark,
                          ),
                        ),
                      ),
                      Text(
                        a['type']!,
                        style: const TextStyle(fontSize: 12, color: kTextGrey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Rekomendasi
        ProfileCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saran Dokter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 8),
              ...recommendations.map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(fontSize: 14, color: kTextDark),
                      ),
                      Expanded(
                        child: Text(
                          r,
                          style: const TextStyle(
                            fontSize: 14,
                            color: kTextDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String status;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: kTextDark),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 13, color: kTextGrey)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(status, style: TextStyle(fontSize: 11, color: c)),
          ),
        ],
      ),
    );
  }
}

class MetricPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String detail;

  const MetricPill({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final c = trendColor(detail);
    final bool isChange =
        detail.trim().startsWith('+') || detail.trim().startsWith('-');

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: c, size: 26),
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
                  detail.trim().startsWith('-')
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 12,
                  color: c,
                ),
              if (isChange) const SizedBox(width: 3),
              Flexible(
                child: Text(
                  detail,
                  style: TextStyle(fontSize: 11, color: c),
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

/// ================== TAB 2: TARGET ==================

class GoalData {
  final String title;
  final double current;
  final double target;
  final String unit;

  GoalData({
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
  });

  double get progress =>
      target == 0 ? 0 : (current / target).clamp(0, 1).toDouble();
}

class VitalsData {
  final String label;
  final String value;
  final String change;
  final IconData icon;

  VitalsData({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
  });
}

class GoalsTab extends StatelessWidget {
  final HealthStats? healthStats;

  const GoalsTab({super.key, this.healthStats});

  @override
  Widget build(BuildContext context) {
    final hs = healthStats;

    final double weight = hs?.weightKg ?? 78;
    final bpmBmi = hs?.bmi;

    final goals = [
      GoalData(
        title: 'Target Penurunan Berat Badan',
        current: weight,
        target: 75,
        unit: 'kg',
      ),
      GoalData(
        title: 'Asupan Air Harian',
        current: 2.5,
        target: 3.0,
        unit: 'L',
      ),
      GoalData(
        title: 'Rata-rata Jam Tidur',
        current: 6.8,
        target: 7.5,
        unit: 'jam',
      ),
      GoalData(
        title: 'Waktu Olahraga Mingguan',
        current: 180,
        target: 200,
        unit: 'menit',
      ),
    ];

    final vitals = [
      VitalsData(
        label: 'Berat Badan',
        value: weight == 0 ? '-' : '${weight.toStringAsFixed(1)} kg',
        change: '-1.5',
        icon: Icons.scale_outlined,
      ),
      VitalsData(
        label: 'IMT',
        value: bpmBmi == null ? '-' : bpmBmi.toStringAsFixed(1),
        change: '+0.4',
        icon: Icons.straighten,
      ),
      VitalsData(
        label: 'Detak Jantung (Istirahat)',
        value: '62 bpm',
        change: 'stabil',
        icon: Icons.favorite_border,
      ),
      VitalsData(
        label: 'Tekanan Darah',
        value: (hs == null || hs.systolic == 0 || hs.diastolic == 0)
            ? '-'
            : '${hs.systolic}/${hs.diastolic} mmHg',
        change: hs == null
            ? 'Perlu perhatian'
            : classifyBloodPressure(hs.systolic, hs.diastolic),
        icon: Icons.monitor_heart_outlined,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        ProfileCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progres Target Kesehatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),
              ...goals.map(
                (g) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GoalProgressRow(goal: g),
                ),
              ),
            ],
          ),
        ),
        ProfileCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perbandingan Vital (vs. Bulan Lalu)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),
              ...vitals.map(
                (v) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _VitalsRow(data: v),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalProgressRow extends StatelessWidget {
  final GoalData goal;

  const _GoalProgressRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          goal.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kTextDark,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${goal.current.toStringAsFixed(1)} ${goal.unit}',
              style: const TextStyle(fontSize: 12, color: kTextGrey),
            ),
            const SizedBox(width: 4),
            const Text('•', style: TextStyle(color: kTextGrey)),
            const SizedBox(width: 4),
            Text(
              'Target ${goal.target.toStringAsFixed(1)} ${goal.unit}',
              style: const TextStyle(fontSize: 12, color: kTextGrey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: goal.progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5F0FF),
            valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryTeal),
          ),
        ),
      ],
    );
  }
}

class _VitalsRow extends StatelessWidget {
  final VitalsData data;

  const _VitalsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = trendColor(data.change);

    IconData arrow;
    if (data.change.trim().startsWith('-')) {
      arrow = Icons.arrow_downward;
    } else if (data.change.trim().startsWith('+')) {
      arrow = Icons.arrow_upward;
    } else {
      arrow = Icons.horizontal_rule;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(data.icon, color: kPrimaryTealDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.value,
                style: const TextStyle(fontSize: 12, color: kTextGrey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: c.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(arrow, size: 14, color: c),
              const SizedBox(width: 4),
              Text(data.change, style: TextStyle(fontSize: 12, color: c)),
            ],
          ),
        ),
      ],
    );
  }
}

/// ================== TAB 3: PENGHARGAAN ==================

class AwardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color iconColor;

  AwardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.iconColor,
  });
}

class AwardsTab extends StatelessWidget {
  const AwardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final awards = [
      AwardData(
        icon: Icons.run_circle_outlined,
        title: 'Pelari Marathon',
        subtitle: 'Menempuh 42 km',
        bgColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1E88E5),
      ),
      AwardData(
        icon: Icons.access_time_filled,
        title: 'Tidur Konsisten',
        subtitle: '7 hari berturut-turut',
        bgColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF43A047),
      ),
      AwardData(
        icon: Icons.water_drop_outlined,
        title: 'Master Hidrasi',
        subtitle: 'Minum 2L / hari',
        bgColor: const Color(0xFFF3E5F5),
        iconColor: const Color(0xFF8E24AA),
      ),
      AwardData(
        icon: Icons.directions_walk_outlined,
        title: 'Pejalan Harian',
        subtitle: '10.000 langkah',
        bgColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFB8C00),
      ),
      AwardData(
        icon: Icons.fitness_center_outlined,
        title: 'Rajin Latihan',
        subtitle: '4x / minggu',
        bgColor: const Color(0xFFFCE4EC),
        iconColor: const Color(0xFFD81B60),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prestasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: awards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final award = awards[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: award.bgColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          award.icon,
                          color: award.iconColor,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        award.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        award.subtitle,
                        style: const TextStyle(fontSize: 12, color: kTextGrey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
