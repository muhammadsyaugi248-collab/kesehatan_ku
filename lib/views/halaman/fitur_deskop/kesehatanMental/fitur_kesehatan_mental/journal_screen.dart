// File: lib/journal_screen.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/database/db_helper.dart';
import 'package:kesehatan_ku/models/kesehatan_models/journal_screen_Model.dart';
import 'package:uuid/uuid.dart'; // <--- PERBAIKAN: Eror 'Uuid'
import 'models/journal_entry.dart';
import 'db_helper.dart'; // <--- Import DbHelper Statis Anda

// ... (Konstanta Warna)

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _journalEntries = [];

  // Eror Uuid akan hilang setelah import dan pub get berhasil
  final Uuid _uuid = const Uuid();

  // Karena DbHelper Anda Statis, Anda tidak perlu field instance di sini.
  // Jika menggunakan Instance (singleton), maka baris ini benar,
  // tetapi Anda harus mengubah implementasi DbHelper.
  // final dbHelper = DatabaseHelper.instance; // Hapus baris ini jika DbHelper Anda statis

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  // Fungsi untuk memuat data dari DB menggunakan DbHelper statis
  void _loadEntries() async {
    // Eror 'The getter 'instance'...' (Jika menggunakan implementasi statis)
    final data = await DbHelper.getJournalEntries();
    setState(() {
      _journalEntries = data;
    });
  }

  // CREATE: Menambahkan entri baru ke DB
  void _addEntry(String title, String content) async {
    final newEntry = JournalEntry(
      id: _uuid.v4(),
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );
    await DbHelper.insertJournalEntry(newEntry);
    _loadEntries();
  }

  // UPDATE: Memperbarui entri di DB
  void _updateEntry(
    JournalEntry oldEntry,
    String newTitle,
    String newContent,
  ) async {
    final updatedEntry = JournalEntry(
      id: oldEntry.id,
      title: newTitle,
      content: newContent,
      timestamp: DateTime.now(),
    );
    await DbHelper.updateJournalEntry(updatedEntry);
    _loadEntries();
  }

  // DELETE: Menghapus entri dari DB
  void _deleteEntry(String id) async {
    await DbHelper.deleteJournalEntry(id);
    _loadEntries();
  }

  // ... (Sisa kode _showEntryDialog)

  @override
  Widget build(BuildContext context) {
    // KOREKSI Eror 'The body might complete normally...'
    return Scaffold(
      // ... (seluruh kode body, AppBar, FAB, dll.)
    );
  }

  Widget _buildJournalCard(JournalEntry entry) {
    return Card(
      // ... (omitted for brevity)
      child: ListTile(
        // ...
        trailing: Row(
          // KOREKSI Eror Typo: MainAxisSizeAxis.min menjadi MainAxisSize.min
          mainAxisSize: MainAxisSize.min,
          children: [
            // ...
          ],
        ),
        // ...
      ),
    );
  }

  // ... (Sisa kode)
}
