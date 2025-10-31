import 'package:flutter/material.dart';

class NewPage extends StatefulWidget {
  const NewPage({
    super.key,
    required this.email,
    required this.nama,
    required this.kota,
  });
  final String email;
  final String nama;
  final String kota;
  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hallo ${widget.nama}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(0, 100, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selamat Datang!", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            const Text("Berikut adalah informasi Anda:"),
            Text("Nama: ${widget.nama}"),
            Text("Email: ${widget.email}"),
            Text("Kota: ${widget.kota}"),
            Text('silahkan keluar!'),
          ],
        ),
      ),
    );
  }
}
