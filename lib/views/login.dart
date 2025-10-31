import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/register.dart';

// --- File: login_screen.dart ---

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controller untuk mengambil input dari field Email dan Password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Kunci global untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // 3. Fungsi yang akan dipanggil saat tombol Login ditekan
  void _handleLogin() {
    // Validasi form. Jika semua TextFormField valid
    if (_formKey.currentState!.validate()) {
      // Ambil nilai email dan password
      String email = _emailController.text;
      String password = _passwordController.text;

      // TODO: Di sini Anda akan menambahkan LOGIKA LOGIN nyata
      // (misalnya: memanggil API, memeriksa database, dsb.)

      // Contoh output di konsol:
      print('Email: $email');
      print('Password: $password');

      // Contoh simulasi navigasi ke Home Screen setelah login sukses (ganti dengan rute Anda)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login berhasil untuk: $email')));
    }
  }

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
                  _buildPasswordField(),
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
                      print('Continue as Guest ditekan!');
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // Gradien warna seperti pada gambar
        gradient: const LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF90F35D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Text("😨", style: TextStyle(fontSize: 80)),
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true, // Menyembunyikan teks (untuk password)
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(),
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 8) {
          return 'Password minimal 8 karakter';
        }
        return null;
      },
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
        onPressed: _handleLogin,
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
    return Container(
      width: double.infinity,
      // Tombol Register tidak memiliki gradien, hanya border
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => register()),
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
