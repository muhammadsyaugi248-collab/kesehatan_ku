// File: lib/db_helper.dart (Sudah termasuk USER, BOOKING, dan JURNAL)

import 'package:kesehatan_ku/models/booking.dart';
import 'package:kesehatan_ku/models/kesehatan_models/journal_screen_Model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kesehatan_ku/models/user_model.dart';
import 'package:kesehatan_ku/models/sehat_model.dart';
import 'package:kesehatan_ku/models/journal_entry.dart'; // Import Model Jurnal

class DbHelper {
  static const tableUser = 'users';
  static const tableStudent = 'students';
  static const tableBooking = 'bookings';
  static const tableJournal = 'journal_entries'; // Nama Tabel Jurnal

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'ppkd.db'),
      version: 3, // ⚠️ NAIKKAN VERSI KE V3 UNTUK MENAMBAH TABEL JURNAL
      onCreate: (db, version) async {
        // Pembuatan Tabel USER, BOOKING, dan STUDENTS (diasumsikan sudah ada)
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)",
        );
        // ... (CREATE TABLE booking)

        // 🆕 Buat tabel Jurnal Harian
        await db.execute('''
          CREATE TABLE $tableJournal(
            id TEXT PRIMARY KEY, 
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE $tableJournal(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              timestamp INTEGER NOT NULL
            )
          ''');
        }
        // ... (Logika onUpgrade lainnya)
      },
    );
  }

  // ==================== JURNAL HARIAN (CRUD) ====================
  // CREATE JOURNAL ENTRY
  static Future<int> insertJournalEntry(JournalEntry entry) async {
    final dbs = await db();
    return await dbs.insert(tableJournal, {
      'id': entry.id,
      'title': entry.title,
      'content': entry.content,
      'timestamp': entry.timestamp.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ ALL JOURNAL ENTRIES
  static Future<List<JournalEntry>> getJournalEntries() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableJournal,
      orderBy: "timestamp DESC",
    );

    return results.map((map) {
      return JournalEntry(
        id: map['id'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      );
    }).toList();
  }

  // UPDATE JOURNAL ENTRY
  static Future<int> updateJournalEntry(JournalEntry entry) async {
    final dbs = await db();
    return await dbs.update(
      tableJournal,
      {
        'title': entry.title,
        'content': entry.content,
        'timestamp': entry.timestamp.millisecondsSinceEpoch,
      },
      where: "id = ?",
      whereArgs: [entry.id],
    );
  }

  // DELETE JOURNAL ENTRY
  static Future<int> deleteJournalEntry(String id) async {
    final dbs = await db();
    return await dbs.delete(tableJournal, where: "id = ?", whereArgs: [id]);
  }

  // ... (Metode static USER, SISWA, BOOKING lainnya)
}
