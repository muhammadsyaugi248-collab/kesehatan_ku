import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kesehatan_ku/models/userfirebasemodel.dart';
import 'package:kesehatan_ku/services/firebase.dart';
import 'package:kesehatan_ku/views/login_firebase/login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controller input
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Key form untuk validasi
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Visibility password
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Tombol enabled / disabled
  bool _isButtonEnabled = false;

  // State user
  Userfirebasemodel user = Userfirebasemodel();

  @override
  void initState() {
    super.initState();
    // Listener untuk cek form terisi
    fullNameController.addListener(_checkFormFields);
    emailController.addListener(_checkFormFields);
    passwordController.addListener(_checkFormFields);
    confirmPasswordController.addListener(_checkFormFields);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Cek apakah semua field tidak kosong
  void _checkFormFields() {
    final bool currentlyEnabled =
        fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

    if (_isButtonEnabled != currentlyEnabled) {
      setState(() {
        _isButtonEnabled = currentlyEnabled;
      });
    }
  }

  // Handle register ditekan
  Future<void> _handleRegistration() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Mohon lengkapi data dengan benar."),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    // Optional: matikan tombol sementara
    setState(() {
      _isButtonEnabled = false;
    });

    try {
      final result = await FirebaseService.registerUser(
        email: emailController.text.trim(),
        username: fullNameController.text.trim(),
        password: passwordController.text,
      );

      setState(() {
        user = result;
      });

      // Tampilkan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pendaftaran Berhasil!"),
          backgroundColor: Colors.teal,
        ),
      );

      // Pindah ke login (replace agar tidak bisa kembali ke register dengan back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Tampilkan pesan error dari Firebase (email dipakai, network, dll)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Register gagal (${e.code})"),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } catch (e) {
      // Error lain (tidak terduga)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi error: $e"),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      // Hidupkan lagi tombol kalau field masih terisi
      _checkFormFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ⬇⬇⬇ DI SINI YANG DIGANTI
      backgroundColor: const Color.fromARGB(255, 201, 231, 226),
      // sebelumnya: Color(0xFFF8FBFE)
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  blurRadius: 24.0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),

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

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Join ',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Kesehatanku',
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

                  // Full Name
                  _buildTextFormField(
                    label: 'Full Name',
                    hint: 'John Cena',
                    controller: fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama lengkap harus diisi';
                      }
                      return null;
                    },
                  ),

                  // Email
                  _buildTextFormField(
                    label: 'Email',
                    hint: 'your.email@example.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),

                  // Password
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

                  // Confirm Password
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

                  // Tombol Register (gradient)
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: _isButtonEnabled
                          ? const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _handleRegistration : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled
                            ? Colors.transparent
                            : Colors.grey.shade300,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isButtonEnabled
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Login
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
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

                  // Guest
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => LoginScreen()),
                  //     );
                  //   },
                  //   child: const Text(
                  //     'Continue as Guest',
                  //     style: TextStyle(color: Colors.grey, fontSize: 14),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TEXT FIELD BIASA
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
            ),
          ),
        ],
      ),
    );
  }

  // TEXT FIELD PASSWORD
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
            obscureText: !isVisible,
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
