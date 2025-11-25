import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/bottom_navigator/bottom_navigator.dart';
import 'package:kesehatan_ku/views/login_firebase/login.dart';
import 'package:kesehatan_ku/views/login_screen_sqflite/login.dart';

// Definisi warna utama untuk konsistensi dengan desain Figma
const _primaryColor = Color(0xFF4C7FFF); // Warna biru utama
const _greyColor = Color(0xFF6A6A6A); // Warna abu-abu untuk teks sekunder
const _accentRed = Color(0xFFFF4C4C); // Warna merah untuk Logout

// --- MAIN WIDGET ---
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State untuk switch Dark Mode dan Notifikasi
  bool _isDarkModeEnabled = false;
  bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 231, 226),
      // Background yang lebih terang
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.settings),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 201, 231, 226),
        centerTitle: false,
        toolbarHeight: 80, // Tambahkan tinggi toolbar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              '~Manage your preferences',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // 1. BAGIAN ACCOUNT
          _buildSettingsSection(
            context,
            title: 'Account',
            children: [
              // Semua tile navigasi di bagian ini akan memiliki ikon panah (true)
              // _buildAccountTile(
              //   context,
              //   icon: Icons.person_outline,
              //   title: 'Edit Profile',
              //   showTrailingIcon: true,
              // ),
              _buildAccountTile(
                context,
                icon: Icons.lock_outline,
                title: 'Change Password',
                showTrailingIcon: true,
              ),
              _buildAccountTile(
                context,
                icon: Icons.security_outlined,
                title: 'Security & Authentication',
                showTrailingIcon: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. BAGIAN PREFERENCES
          _buildSettingsSection(
            context,
            title: 'Preferences',
            children: [
              // Pilihan Bahasa (Juga sebagai navigasi)
              _buildInfoTile(
                icon: Icons.language,
                title: 'Language',
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Indonesia',
                      style: TextStyle(color: _greyColor, fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFC0C0C0),
                    ),
                  ],
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menuju pemilihan Bahasa')),
                  );
                },
              ),

              // Switch Dark Mode
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: _isDarkModeEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkModeEnabled = value;
                  });
                },
              ),

              // Switch Enable Notifications
              _buildSwitchTile(
                icon: Icons.notifications_none,
                title: 'Enable Notifications',
                value: _isNotificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. BAGIAN APP INFO
          _buildSettingsSection(
            context,
            title: 'App Info',
            children: [
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'App Version',
                trailing: const Text(
                  '1.0.0',
                  style: TextStyle(color: _greyColor, fontSize: 15),
                ),
                onTap: () {}, // Tidak ada aksi karena hanya informasi
              ),
              // Semua tile navigasi di bagian ini akan memiliki ikon panah (true)
              _buildAccountTile(
                context,
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                showTrailingIcon: true,
              ),
              _buildAccountTile(
                context,
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                showTrailingIcon: true,
              ),
              _buildAccountTile(
                context,
                icon: Icons.forum_outlined,
                title: 'Send Feedback',
                showTrailingIcon: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. BAGIAN ADDITIONAL
          _buildSettingsSection(
            context,
            title: 'Additional',
            children: [
              // Semua tile navigasi di bagian ini akan memiliki ikon panah (true)
              _buildAccountTile(
                context,
                icon: Icons.watch_outlined,
                title: 'Wearable Integration',
                showTrailingIcon: true,
              ),
              _buildAccountTile(
                context,
                icon: Icons.delete_outline,
                title: 'Clear Cache',
                showTrailingIcon: true,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // 5. TOMBOL LOGOUT (dengan gradient merah/oranye)
          SizedBox(
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // Menggunakan gradient untuk meniru desain Figma
                gradient: LinearGradient(
                  colors: [
                    _accentRed,
                    const Color(0xFFFF8B4C),
                  ], // Dari merah ke oranye
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accentRed.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  // TODO: Tambahkan logika logout di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anda telah menekan tombol Logout.'),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // Transparan agar gradient terlihat
                  shadowColor: Colors.transparent, // Hilangkan shadow bawaan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  elevation: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- WIDGET PEMBANTU ---

  // Template untuk membuat bagian (section) Pengaturan
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50), // Warna judul section yang gelap
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Memisahkan setiap ListTile dengan Divider kecuali yang terakhir
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Color(0xFFE0E0E0),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Template untuk item yang memiliki aksi (Account, Clear Cache, dll)
  // Default showTrailingIcon kini diatur ke false, namun di bagian build kita set ke true
  Widget _buildAccountTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool showTrailingIcon = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: _greyColor),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      // Jika showTrailingIcon = true, tampilkan panah
      trailing: showTrailingIcon
          ? const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFC0C0C0),
            )
          : null,
      onTap: () {
        // Logika navigasi sederhana untuk demonstrasi
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Menuju halaman $title')));
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // Template untuk item info (Language, App Version)
  // Diubah untuk menerima onTap agar Language dapat berfungsi sebagai navigasi
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: _greyColor),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // Template untuk item dengan Switch (Dark Mode, Notifications)
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: _greyColor),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: _primaryColor, // Warna biru utama saat aktif
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// --- APP UTAMA UNTUK DEMONSTRASI ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KesehatanKu Settings Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _primaryColor,
        fontFamily: 'Roboto', // Menggunakan font standar yang bersih
        useMaterial3: true,
      ),
      home: const BottomNavigator(),
    );
  }
}
