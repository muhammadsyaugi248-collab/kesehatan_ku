// lib/views/halaman/profile/edit_profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// model HealthStats kamu
import 'package:kesehatan_ku/models/health_stats.dart';

/// ================== WARNA & GRADIENT (SAMA DENGAN PROFILE) ==================

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

/// ================== LOADING DIALOG ==================

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

/// ================== EDIT PROFILE SCREEN (TANPA EDIT FOTO) ==================

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;
  final String? initialPhotoUrl;
  final HealthStats? initialHealthStats;

  const EditProfileScreen({
    super.key,
    required this.initialUsername,
    required this.initialEmail,
    this.initialPhotoUrl,
    this.initialHealthStats,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  // vital stats controllers
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _sysController;
  late TextEditingController _diaController;
  late TextEditingController _glucoseController;
  late TextEditingController _uricController;
  late TextEditingController _hdlController;
  late TextEditingController _ldlController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _emailController = TextEditingController(text: widget.initialEmail);

    final h = widget.initialHealthStats;
    _weightController = TextEditingController(
      text: h == null || h.weightKg == 0 ? '' : h.weightKg.toStringAsFixed(1),
    );
    _heightController = TextEditingController(
      text: h == null || h.heightCm == 0 ? '' : h.heightCm.toStringAsFixed(0),
    );
    _sysController = TextEditingController(
      text: h == null || h.systolic == 0 ? '' : h.systolic.toString(),
    );
    _diaController = TextEditingController(
      text: h == null || h.diastolic == 0 ? '' : h.diastolic.toString(),
    );
    _glucoseController = TextEditingController(
      text: h == null || h.glucose == 0 ? '' : h.glucose.toStringAsFixed(0),
    );
    _uricController = TextEditingController(
      text: h == null || h.uricAcid == 0 ? '' : h.uricAcid.toStringAsFixed(1),
    );
    _hdlController = TextEditingController(
      text: h == null || h.hdl == 0 ? '' : h.hdl.toStringAsFixed(0),
    );
    _ldlController = TextEditingController(
      text: h == null || h.ldl == 0 ? '' : h.ldl.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _sysController.dispose();
    _diaController.dispose();
    _glucoseController.dispose();
    _uricController.dispose();
    _hdlController.dispose();
    _ldlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    final uid = user.uid;
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();

    // ================== AMBIL ANGKA VITAL ==================
    double parseDouble(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

    int parseInt(TextEditingController c) => int.tryParse(c.text) ?? 0;

    final stats = HealthStats(
      weightKg: parseDouble(_weightController),
      heightCm: parseDouble(_heightController),
      systolic: parseInt(_sysController),
      diastolic: parseInt(_diaController),
      glucose: parseDouble(_glucoseController),
      uricAcid: parseDouble(_uricController),
      hdl: parseDouble(_hdlController),
      ldl: parseDouble(_ldlController),
    );

    // ================== UPDATE FIRESTORE ==================
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await docRef.set({
      'username': username,
      'email': email,
      'healthStats': stats.toMap(),
      'vitalsUpdatedByUser': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // ================== UPDATE AUTH DISPLAYNAME ==================
    await user.updateDisplayName(username);
    // (email di FirebaseAuth tidak diubah, untuk menghindari re-auth error)
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
        const SnackBar(
          content: Text('Profil & vital stats berhasil diperbarui'),
        ),
      );

      Navigator.pop(context, true); // kirim flag changed = true
    } catch (e) {
      if (!mounted) return;
      hideLoadingDialog(context);
      setState(() => _saving = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update profil: $e')));
    }
  }

  InputDecoration _vitalFieldDecoration({String? suffix}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      suffixText: suffix,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialUsername.isNotEmpty
        ? widget.initialUsername[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Back
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Back to Profile',
                      style: TextStyle(fontSize: 14, color: kTextGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Card atas (avatar + nama + email + label Member)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: headerGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            (widget.initialPhotoUrl != null &&
                                widget.initialPhotoUrl!.isNotEmpty)
                            ? NetworkImage(widget.initialPhotoUrl!)
                            : null,
                        child:
                            (widget.initialPhotoUrl == null ||
                                widget.initialPhotoUrl!.isEmpty)
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
                      const SizedBox(height: 12),
                      Text(
                        widget.initialUsername,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.initialEmail,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Member',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Username + Email card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xFFF1FAFB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: kPrimaryTealDark,
                              width: 1.4,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xFFF1FAFB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: kPrimaryTealDark,
                              width: 1.4,
                            ),
                          ),
                        ),
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
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Vital Stats card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF8FF),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vital Stats',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Berat badan
                      _VitalRow(
                        label: 'Berat Badan',
                        icon: Icons.scale_outlined,
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _vitalFieldDecoration(suffix: 'kg'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tinggi badan
                      _VitalRow(
                        label: 'Tinggi Badan',
                        icon: Icons.straighten,
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: _vitalFieldDecoration(suffix: 'cm'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tekanan darah
                      _VitalRow(
                        label: 'Tekanan Darah',
                        icon: Icons.monitor_heart_outlined,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _sysController,
                                keyboardType: TextInputType.number,
                                decoration: _vitalFieldDecoration(suffix: ''),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '/',
                              style: TextStyle(fontSize: 16, color: kTextGrey),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextFormField(
                                controller: _diaController,
                                keyboardType: TextInputType.number,
                                decoration: _vitalFieldDecoration(
                                  suffix: 'mmHg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Gula darah
                      _VitalRow(
                        label: 'Diabetes (Gula Darah)',
                        icon: Icons.water_drop_outlined,
                        child: TextFormField(
                          controller: _glucoseController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _vitalFieldDecoration(suffix: 'mg/dL'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Asam urat
                      _VitalRow(
                        label: 'Asam Urat',
                        icon: Icons.bubble_chart_outlined,
                        child: TextFormField(
                          controller: _uricController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _vitalFieldDecoration(suffix: 'mg/dL'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kolesterol HDL
                      _VitalRow(
                        label: 'Kolesterol Baik (HDL)',
                        icon: Icons.favorite_outline,
                        child: TextFormField(
                          controller: _hdlController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _vitalFieldDecoration(suffix: 'mg/dL'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kolesterol LDL
                      _VitalRow(
                        label: 'Kolesterol Jahat (LDL)',
                        icon: Icons.heart_broken_outlined,
                        child: TextFormField(
                          controller: _ldlController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _vitalFieldDecoration(suffix: 'mg/dL'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VitalRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;

  const _VitalRow({
    required this.label,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFEFF6FF),
                child: Icon(icon, size: 14, color: kPrimaryTealDark),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
