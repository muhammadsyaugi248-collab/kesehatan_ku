// lib/views/halaman/profile/screen/local_profile_db.dart

import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Database lokal sederhana untuk menyimpan path foto profil.
class LocalProfileDb {
  // ---- singleton ----
  LocalProfileDb._internal();
  static final LocalProfileDb _instance = LocalProfileDb._internal();
  static LocalProfileDb get instance => _instance;

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'local_profile.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY,
            photo_path TEXT
          )
        ''');
      },
    );
  }

  /// Ambil path foto profil (nullable).
  Future<String?> getPhotoPath() async {
    try {
      final db = await _database;
      final result = await db.query(
        'profile',
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );
      if (result.isEmpty) return null;
      final value = result.first['photo_path'];
      if (value == null) return null;
      return value as String;
    } catch (e) {
      // Jangan bikin app crash, cukup log saja
      // debugPrint('LocalProfileDb getPhotoPath error: $e');
      return null;
    }
  }

  /// Simpan / update path foto lokal.
  Future<void> savePhotoPath(String? path) async {
    try {
      final db = await _database;

      if (path == null || path.isEmpty) {
        await db.delete('profile', where: 'id = ?', whereArgs: [1]);
        return;
      }

      await db.insert('profile', {
        'id': 1,
        'photo_path': path,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      // debugPrint('LocalProfileDb savePhotoPath error: $e');
    }
  }
}
