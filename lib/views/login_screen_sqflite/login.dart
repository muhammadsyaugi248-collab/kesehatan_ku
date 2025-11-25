import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kesehatan_ku/database/db_helper.dart';
import 'package:kesehatan_ku/preferences/preference_handler.dart';
import 'package:kesehatan_ku/views/bottom_navigator/bottom_navigator.dart';

import 'package:kesehatan_ku/views/register_sqflite/register.dart';

class LoginScreensqflite extends StatefulWidget {
  const LoginScreensqflite({super.key});

  @override
  State<LoginScreensqflite> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreensqflite> {
  // 1. Controller untuk mengambil input dari field Email dan Password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 2. Kunci global untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // 3. Fungsi yang akan dipanggil saat tombol Login ditekan
  // void _handleLogin() {
  //   // Validasi form. Jika semua TextFormField valid
  //   if (_formKey.currentState!.validate()) {
  //     // Ambil nilai email dan password
  //     String email = _emailController.text;
  //     String password = _passwordController.text;

  //     // TODO: Di sini Anda akan menambahkan LOGIKA LOGIN nyata
  //     // (misalnya: memanggil API, memeriksa database, dsb.)

  //     // Contoh output di konsol:
  //     print('Email: $email');
  //     print('Password: $password');

  //     // Contoh simulasi navigasi ke Home Screen setelah login sukses (ganti dengan rute Anda)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Login berhasil untuk: $email'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    // Penting: Membuang controller saat widget dihapus untuk menghindari kebocoran memori.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background body berwarna putih kehijauan muda sesuai gambar
      backgroundColor: const Color.fromARGB(255, 206, 243, 234),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            // Gaya Box (Card) di tengah layar
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // 1. LOGO / IKON
                  _buildLogoIcon(),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  //  2. FIELD EMAIL
                  _buildEmailField(),
                  const SizedBox(height: 20),

                  // 3. FIELD PASSWORD & LUPA PASSWORD
                  _buildPasswordField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
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
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print('Forgot Password ditekan!');
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xFF00BFA5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. TOMBOL LOGIN
                  _buildLoginButton(),
                  const SizedBox(height: 15),

                  // 5. TOMBOL REGISTER
                  _buildRegisterButton(),
                  const SizedBox(height: 15),

                  //  CONTINUE AS GUEST
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigator(),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(color: Colors.grey),
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

  // Helper Methods untuk Membangun UI per Komponen

  Widget _buildLogoIcon() {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(20),
      child: Image(image: AssetImage('assets/images/logo.png')),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   // Gradien warna seperti pada gambar
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFF00C9A7), Color(0xFF90F35D)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      // ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'your.email@example.com',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        // TODO: Tambahkan validasi email yang lebih kompleks jika perlu
        return null;
      },
    );
  }

  Widget _buildPasswordField({
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
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
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

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // Gradien warna untuk tombol LOGIN
        gradient: const LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF90F35D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            print(_emailController.text);
            PreferenceHandler.saveLogin(true);
            final data = await DbHelper.loginUser(
              email: _emailController.text,
              password: _passwordController.text,
            );
            if (data != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigator(
                    //email: emailController.text,
                    //name: usernameController.text,
                    //age: "",
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(msg: "Email atau password salah");
            }
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Validation Error"),
                  content: Text("Please fill all fields"),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Dont have account? register"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationAppsqflite(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors
              .transparent, // Membuat background ElevatedButton transparan
          shadowColor: Colors.transparent, // Menghilangkan bayangan
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      // Tombol Register tidak memiliki gradien, hanya border
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationAppsqflite()),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ), // Border abu-abu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Don't have an account? Register",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
