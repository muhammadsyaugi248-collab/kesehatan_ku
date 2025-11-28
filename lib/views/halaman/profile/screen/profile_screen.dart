// lib/views/halaman/profile/profile_screen.dart

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        _loadingProfile = false;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      _firebaseUser = user;
      _userDoc = doc;
      _loadingProfile = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ========= PERUBAHAN 1: logika member since pakai creationTime =========
  String _memberSinceText() {
    final user = _firebaseUser;
    final created = user?.metadata.creationTime;

    if (created == null) return 'Member';

    final dt = created.toLocal();

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

    final monthName = months[dt.month - 1];
    final year = dt.year.toString();

    // Contoh hasil: "Member since November 2025"
    return 'Member since $monthName $year';
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

    return Container(
      decoration: const BoxDecoration(gradient: headerGradient),
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info profil
          Padding(
            padding: const EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto profil
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
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
                const SizedBox(width: 16),
                // Nama & email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
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
                          // ========= PERUBAHAN 2: teks tidak dipotong "..." =========
                          Flexible(
                            child: Text(
                              _memberSinceText(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol Edit Profile
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final changed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            initialUsername: username,
                            initialEmail: email,
                            initialPhotoUrl: photoUrl,
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
            children: const [HealthTab(), GoalsTab(), AwardsTab()],
          ),
        ),
      ),
    );
  }
}

/// ================== EDIT PROFILE SCREEN ==================

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;
  final String? initialPhotoUrl;

  const EditProfileScreen({
    super.key,
    required this.initialUsername,
    required this.initialEmail,
    this.initialPhotoUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  File? _pickedImageFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _pickedImageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    final uid = user.uid;
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    String? photoUrl = widget.initialPhotoUrl;

    // upload foto kalau ada
    if (_pickedImageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('$uid.jpg');

      await ref.putFile(_pickedImageFile!);
      photoUrl = await ref.getDownloadURL();
    }

    // update Firestore
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await docRef.set({
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // update Auth displayName & photoURL
    await user.updateDisplayName(username);
    if (photoUrl != null && photoUrl.isNotEmpty) {
      await user.updatePhotoURL(photoUrl);
    }
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    showLoadingDialog(context);

    try {
      await _saveProfile();

      if (!mounted) return;
      hideLoadingDialog(context);
      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      hideLoadingDialog(context);
      setState(() => _saving = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update profil: $e')));
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryTealDark, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialUsername.isNotEmpty
        ? widget.initialUsername[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: kProfileBg,
      body: SafeArea(
        child: Column(
          children: [
            // header gradient seperti profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: const BoxDecoration(gradient: headerGradient),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // avatar + tombol kamera
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _pickedImageFile != null
                            ? FileImage(_pickedImageFile!)
                            : (widget.initialPhotoUrl != null &&
                                  widget.initialPhotoUrl!.isNotEmpty)
                            ? NetworkImage(widget.initialPhotoUrl!)
                                  as ImageProvider
                            : null,
                        child:
                            (_pickedImageFile == null &&
                                (widget.initialPhotoUrl == null ||
                                    widget.initialPhotoUrl!.isEmpty))
                            ? Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00838F),
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // body putih dengan field
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _usernameController,
                        decoration: _fieldDecoration('Masukkan nama lengkap'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        decoration: _fieldDecoration('Masukkan email aktif'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _onSavePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Simpan Perubahan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
  const HealthTab({super.key});

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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
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
  const GoalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final goals = [
      GoalData(
        title: 'Target Penurunan Berat Badan',
        current: 78,
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
        value: '78 kg',
        change: '-1.5',
        icon: Icons.scale_outlined,
      ),
      VitalsData(
        label: 'IMT',
        value: '25.3',
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
        value: '135/85 mmHg',
        change: 'Perlu perhatian',
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
