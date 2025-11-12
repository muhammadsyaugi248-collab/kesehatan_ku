// File: lib/db_helper.dart (Kode Lengkap)

import 'package:kesehatan_ku/models/booking.dart';
import 'package:kesehatan_ku/models/kesehatan_models/journal_screen_Model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kesehatan_ku/models/user_model.dart'; // Import UserModel
import 'package:kesehatan_ku/models/sehat_model.dart'; // Asumsi StudentModel ada di sini
// import 'package:kesehatan_ku/models/journal_entry.dart';

class DbHelper {
  // --- KONSTANTA TABEL ---
  static const tableUser = 'users';
  static const tableStudent = 'students';
  static const tableBooking = 'bookings';
  static const tableJournal = 'journal_entries';

  // Inisialisasi database
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'ppkd.db'),
      version: 3, // Versi tetap 3 untuk Jurnal
      onCreate: (db, version) async {
        // 1. BUAT TABEL USER (Login/Register)
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)",
        );
        // (Asumsi CREATE TABLE students ada di sini)

        // 2. BUAT TABEL BOOKING
        await db.execute('''
          CREATE TABLE $tableBooking(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            doctorName TEXT,
            specialty TEXT,
            dateTime TEXT,
            price REAL,
            points INTEGER,
            isActive INTEGER,
            isCancelled INTEGER,
            isCompleted INTEGER,
            hasRated INTEGER
          )
        ''');

        // 3. BUAT TABEL JURNAL
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
        if (oldVersion < 2) {
          // Upgrade dari V1 ke V2 (Booking)
          await db.execute('''
            CREATE TABLE $tableBooking(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              doctorName TEXT,
              specialty TEXT,
              dateTime TEXT,
              price REAL,
              points INTEGER,
              isActive INTEGER,
              isCancelled INTEGER,
              isCompleted INTEGER,
              hasRated INTEGER
            )
          ''');
        }

        if (oldVersion < 3) {
          // Upgrade dari V2 ke V3 (Jurnal)
          await db.execute('''
            CREATE TABLE $tableJournal(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              timestamp INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  // ==================== USER (LOGIN/REGISTER) ====================
  // REGISTER USER (Tidak Dihapus)
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // LOGIN USER (Tidak Dihapus)
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      // Pastikan Anda memiliki UserModel.fromMap
      // return UserModel.fromMap(results.first);
      // Karena UserModel tidak tersedia, kita return hasil map
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  // ==================== SISWA ====================
  static Future<void> createStudent(StudentModel student) async {
    final dbs = await db();
    await dbs.insert(
      tableStudent,
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<StudentModel>> getAllStudent() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableStudent);
    // Pastikan StudentModel.fromMap tersedia
    return results.map((e) => StudentModel.fromMap(e)).toList();
  }

  // ==================== BOOKING ====================
  static Future<void> createBooking(BookingModel booking) async {
    final dbs = await db();
    await dbs.insert(
      tableBooking,
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<BookingModel>> getAllBookings() async {
    final dbs = await db();
    final result = await dbs.query(tableBooking, orderBy: "dateTime DESC");
    return result.map((e) => BookingModel.fromMap(e)).toList();
  }

  static Future<int> updateBookingStatus(
    int id, {
    bool? isCancelled,
    bool? hasRated,
  }) async {
    final dbs = await db();
    final data = <String, dynamic>{};
    if (isCancelled != null) data['isCancelled'] = isCancelled ? 1 : 0;
    if (hasRated != null) data['hasRated'] = hasRated ? 1 : 0;
    return await dbs.update(
      tableBooking,
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> deleteBooking(int id) async {
    final dbs = await db();
    return await dbs.delete(tableBooking, where: "id = ?", whereArgs: [id]);
  }

  // ==================== JURNAL HARIAN (CRUD) ====================
  static Future<int> insertJournalEntry(JournalEntry entry) async {
    final dbs = await db();
    return await dbs.insert(tableJournal, {
      'id': entry.id,
      'title': entry.title,
      'content': entry.content,
      'timestamp': entry.timestamp.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

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

  static Future<int> deleteJournalEntry(String id) async {
    final dbs = await db();
    return await dbs.delete(tableJournal, where: "id = ?", whereArgs: [id]);
  }
}
