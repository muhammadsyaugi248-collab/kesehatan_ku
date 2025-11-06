import 'package:kesehatan_ku/models/booking.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kesehatan_ku/models/user_model.dart';
import 'package:kesehatan_ku/models/sehat_model.dart';

class DbHelper {
  static const tableUser = 'users';
  static const tableStudent = 'students';
  static const tableBooking = 'bookings'; // 🆕 Tambahan

  // Inisialisasi database
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'ppkd.db'),
      version: 2, // 🆕 naikkan versi DB supaya onUpgrade terpanggil
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)",
        );

        // 🆕 Buat tabel booking
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // 🆕 Buat tabel booking saat upgrade
        if (oldVersion < 2) {
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
      },
    );
  }

  // ==================== USER ====================
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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
    return results.map((e) => StudentModel.fromMap(e)).toList();
  }

  // ==================== BOOKING ==================== 🆕 Tambahan Baru

  // CREATE BOOKING
  static Future<void> createBooking(BookingModel booking) async {
    final dbs = await db();
    await dbs.insert(
      tableBooking,
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ BOOKING (untuk halaman scanning nanti)
  static Future<List<BookingModel>> getAllBookings() async {
    final dbs = await db();
    final result = await dbs.query(tableBooking, orderBy: "dateTime DESC");
    return result.map((e) => BookingModel.fromMap(e)).toList();
  }

  // UPDATE BOOKING STATUS (akan dipanggil dari scanning)
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

  // DELETE BOOKING
  static Future<int> deleteBooking(int id) async {
    final dbs = await db();
    return await dbs.delete(tableBooking, where: "id = ?", whereArgs: [id]);
  }
}
