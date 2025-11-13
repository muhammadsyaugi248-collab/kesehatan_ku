// File: lib/journal_screen.dart

import 'package:flutter/material.dart';
import 'package:kesehatan_ku/database/db_helper.dart';
import 'package:kesehatan_ku/models/kesehatan_models/journal_screen_Model.dart';
import 'package:kesehatan_ku/views/halaman/fitur_deskop/kesehatanMental/MentalHealthScreen.dart';
import 'package:uuid/uuid.dart'; // FIX: Mengatasi 'Undefined class Uuid'

// Hapus import yang duplikat dan yang tidak perlu dari file ini
// import 'package:kesehatan_ku/database/db_helper.dart';
// import 'models/journal_entry.dart'; // Jika sudah diimport dengan package path di atas
// import 'db_helper.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // --- STATE ---
  List<JournalEntry> _journalEntries = [];
  final Uuid _uuid = const Uuid(); // FIX: Uuid kini dikenal

  // Kontroler untuk dialog input
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // --- FUNGSI CRUD ---

  void _loadEntries() async {
    // FIX: Mengakses DbHelper secara statis (tanpa .instance)
    final data = await DbHelper.getJournalEntries();
    setState(() {
      _journalEntries = data;
    });
  }

  void _addEntry(String newTitle, String newContent) async {
    final newEntry = JournalEntry(
      id: _uuid.v4(),
      title: newTitle,
      content: newContent,
      timestamp: DateTime.now(),
    );
    await DbHelper.insertJournalEntry(newEntry);
    _loadEntries();
  }

  void _updateEntry(JournalEntry oldEntry) async {
    final updatedEntry = JournalEntry(
      id: oldEntry.id,
      title: _titleController.text,
      content: _contentController.text,
      timestamp: DateTime.now(), // Memperbarui timestamp saat edit
    );
    await DbHelper.updateJournalEntry(updatedEntry);
    _loadEntries();
  }

  void _deleteEntry(String id) async {
    await DbHelper.deleteJournalEntry(id);
    _loadEntries();
  }

  // --- DIALOG INPUT ---
  void _showEntryDialog([JournalEntry? entry]) {
    // Reset controllers dan isi jika mode edit
    _titleController.text = entry?.title ?? '';
    _contentController.text = entry?.content ?? '';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(entry == null ? 'Tambah Entri Baru' : 'Edit Entri'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Isi Jurnal'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (entry == null) {
                  _addEntry(_titleController.text, _contentController.text);
                } else {
                  _updateEntry(entry);
                }
                Navigator.of(ctx).pop();
              },
              child: Text(entry == null ? 'Simpan' : 'Perbarui'),
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET CARD ---
  Widget _buildJournalCard(JournalEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          entry.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${entry.content}\n${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          // FIX TYPO: mainAxisSize.min
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: kPrimaryColor),
              onPressed: () => _showEntryDialog(entry),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEntry(entry.id),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Mengembalikan Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal Harian'),
        backgroundColor: kPrimaryColor,
      ),
      body: _journalEntries.isEmpty
          ? const Center(
              child: Text('Belum ada entri jurnal. Tambahkan yang pertama!'),
            )
          : ListView.builder(
              itemCount: _journalEntries.length,
              itemBuilder: (context, index) {
                return _buildJournalCard(_journalEntries[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryDialog(),
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: kBackgroundColor),
      ),
    );
  }
}
