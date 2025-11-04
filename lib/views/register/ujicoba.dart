// Judul: Kode Dart/Flutter untuk Tampilan Registrasi "SehatPlus+" (Stateful dengan Validasi)

// Impor package Flutter material (desain UI Google)
import 'package:flutter/material.dart';

// Fungsi utama aplikasi (titik masuk)
void main() {
  runApp(const RegistrationApp());
}

// Widget utama yang mendefinisikan tema dan struktur aplikasi
class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: 'Kesehatanku Registration',
      theme: ThemeData(
        // Menggunakan warna teal sebagai warna utama untuk fokus input
        primarySwatch: Colors.teal,
        fontFamily: 'Inter', // Menggunakan font Inter (simulasi)
      ),
      // Memulai dengan halaman registrasi
      home: const RegistrationScreen(),
    );
  }
}

// --- Halaman Registrasi (StatefulWidget) ---

// Mengubah menjadi StatefulWidget untuk mengelola state input dan validasi
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controller untuk mengelola input dari setiap TextFormField
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // GlobalKey untuk mengelola state Form dan menjalankan validasi
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State untuk visibilitas password
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // State untuk menentukan apakah tombol harus aktif
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk memantau perubahan teks dan mengaktifkan tombol
    fullNameController.addListener(_checkFormFields);
    emailController.addListener(_checkFormFields);
    phoneController.addListener(_checkFormFields);
    passwordController.addListener(_checkFormFields);
    confirmPasswordController.addListener(_checkFormFields);
  }

  @override
  void dispose() {
    // Pastikan controller dihapus saat widget dibuang untuk mencegah kebocoran memori
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengecek apakah semua field wajib sudah terisi
  void _checkFormFields() {
    final bool currentlyEnabled =
        fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

    if (_isButtonEnabled != currentlyEnabled) {
      setState(() {
        _isButtonEnabled = currentlyEnabled;
      });
    }
  }

  // Fungsi saat tombol registrasi ditekan
  void _handleRegistration() {
    // Validasi form keseluruhan
    if (_formKey.currentState!.validate()) {
      // Jika valid, tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pendaftaran Berhasil!"),
          backgroundColor: Colors.teal,
        ),
      );

      // Cetak data ke konsol
      print('--- Data Registrasi ---');
      print('Nama: ${fullNameController.text}');
      print('Email: ${emailController.text}');
      print('Telepon: ${phoneController.text}');
      print('Password: ${passwordController.text}');
      // Di aplikasi nyata, navigasi ke layar berikutnya (misalnya LoginScreen)
      // Contoh: Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      // Jika tidak valid, tampilkan snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mohon lengkapi data dengan benar."),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold memberikan struktur dasar (AppBar, Body, dll)
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFE), // Latar belakang putih kebiruan
      body: Center(
        // SingleChildScrollView memungkinkan konten digulir jika keyboard muncul
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), // Membatasi lebar
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0), // Sudut membulat
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  blurRadius: 24.0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey, // Pasang GlobalKey ke Form
              child: Column(
                mainAxisSize: MainAxisSize.min, // Menggunakan MainAxisSize.min
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Icon Header
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(20),
                    child: Image(image: AssetImage('assets/images/logo.jpg')),
                  ),

                  // 2. Judul
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 3. Subjudul
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Join ',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'SehatPlus+',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade500,
                          ),
                        ),
                        const TextSpan(text: ' today'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Form Fields
                  _buildTextFormField(
                    label: 'Full Name',
                    hint: 'John Doe',
                    controller: fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama lengkap harus diisi';
                      }
                      return null;
                    },
                  ),
                  _buildTextFormField(
                    label: 'Email',
                    hint: 'your.email@example.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi';
                      }
                      // Regex validasi email sederhana
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  _buildTextFormField(
                    label: 'Phone Number',
                    hint: '+62 812 3456 7890',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon harus diisi';
                      }
                      return null;
                    },
                  ),

                  // Field Password
                  _buildPasswordFormField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: passwordController,
                    isVisible: _isPasswordVisible,
                    onToggle: (visible) {
                      setState(() {
                        _isPasswordVisible = visible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password harus diisi';
                      }
                      if (value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                      return null;
                    },
                  ),

                  // Field Confirm Password
                  _buildPasswordFormField(
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    controller: confirmPasswordController,
                    isVisible: _isConfirmPasswordVisible,
                    onToggle: (visible) {
                      setState(() {
                        _isConfirmPasswordVisible = visible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi password harus diisi';
                      }
                      if (value != passwordController.text) {
                        return 'Konfirmasi password tidak cocok';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // 5. Tombol Register (Gradient)
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      // Menggunakan LinearGradient untuk efek gradien
                      gradient: _isButtonEnabled
                          ? const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null, // Tanpa gradien jika tombol dinonaktifkan
                    ),
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _handleRegistration : null,
                      style: ElevatedButton.styleFrom(
                        // Warna dasar tombol jika dinonaktifkan
                        backgroundColor: _isButtonEnabled
                            ? Colors.transparent
                            : Colors.grey.shade300,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.zero, // Hapus padding default
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // Warna teks putih hanya jika tombol aktif
                          color: _isButtonEnabled
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 6. Tombol Login (Secondary)
                  OutlinedButton(
                    onPressed: () {
                      print('Tombol Login Ditekan!');
                      // Di sini Anda akan menavigasi ke layar Login
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 7. Tautan Guest
                  TextButton(
                    onPressed: () {
                      print('Continue as Guest Ditekan!');
                    },
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Pembantu (Refactored untuk menggunakan TextFormField) ---

  // Widget pembantu untuk membuat TextFormField standar
  Widget _buildTextFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            // Validasi dijalankan saat input kehilangan fokus
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                // Gaya border saat error
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                // Gaya border saat error & fokus
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk membuat TextFormField Password
  Widget _buildPasswordFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isVisible,
    required Function(bool) onToggle,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText:
                !isVisible, // Menggunakan state isVisible untuk menyembunyikan
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
              ),
              // Tombol toggle visibilitas
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () => onToggle(!isVisible),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
