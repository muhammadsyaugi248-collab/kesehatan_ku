import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/login_screen/login.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool isbuttonenable = false;
  final TextEditingController namacontroler = TextEditingController();
  final TextEditingController emailcontroler = TextEditingController();
  final TextEditingController domcontroler = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    emailcontroler.dispose();
    namacontroler.dispose();
    domcontroler.dispose();
  }

  void checkformfield() {
    setState(() {
      isbuttonenable =
          emailcontroler.text.isNotEmpty &&
          namacontroler.text.isNotEmpty &&
          domcontroler.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 12, spreadRadius: 8),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 100, 0, 1),
              const Color.fromRGBO(134, 139, 34, 1),
              Color.fromRGBO(107, 142, 35, 1),
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Container(
                // width: 343,
                // height: 580,
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Text(
                        "Formulir",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nama Lengkap"),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: namacontroler,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukan Nama Anda',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' Di Isi dlu';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            Text("Email"),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: emailcontroler,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukan Email Anda',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'email tidak boleh kosong';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'format email tidak valid';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            Text("pasword"),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: domcontroler,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'pasword',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan Kota Anda';
                                }
                                if (value.length < 8) {
                                  return 'Password minimal 8 karakter';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            Text("Nomor Telepon"),
                            SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukan Nomor Telp Anda',
                              ),
                            ),
                            SizedBox(height: 24),

                            Center(
                              child: SizedBox(
                                width: 400,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff1D61E7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                          // settings: RouteSettings(
                                          //   arguments: {
                                          //     'nama': namacontroler.text,
                                          //     'kota': domcontroler.text,
                                          //     'email': emailcontroler.text,
                                          //   },
                                          // ),
                                        ),

                                        // (route) => false,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Daftar Berhasil"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Masukan Semua Data Dengan Benar",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    print('Nama: ${namacontroler.text}');
                                    print('Email: ${emailcontroler.text}');
                                    print('Kota: ${domcontroler.text}');
                                  },
                                  child: Text(
                                    "Daftar",
                                    style: TextStyle(color: Colors.white),
                                  ),
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
          ),
        ),
      ),
    );
  }
}
