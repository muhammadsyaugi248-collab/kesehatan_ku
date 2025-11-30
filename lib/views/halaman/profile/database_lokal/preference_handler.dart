// lib/preferences/preference_handler.dart

import 'package:shared_preferences/shared_preferences.dart';

/// Helper untuk menyimpan data user secara lokal
/// (username, email, photo path, dll) menggunakan SharedPreferences.
class PreferenceHandler {
  PreferenceHandler._internal();
  static final PreferenceHandler _instance = PreferenceHandler._internal();
  factory PreferenceHandler() => _instance;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _sp async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ================== KEY ==================
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyPhotoLocalPath = 'profile_photo_local_path';
  static const String _keyPhotoRemoteUrl = 'profile_photo_remote_url';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // ================== SAVE / UPDATE ==================

  /// Simpan semua info user sekaligus
  Future<void> saveUserInfo({
    required String userId,
    required String username,
    required String email,
    String? localPhotoPath,
    String? remotePhotoUrl,
    bool isLoggedIn = true,
  }) async {
    final sp = await _sp;
    await sp.setString(_keyUserId, userId);
    await sp.setString(_keyUsername, username);
    await sp.setString(_keyEmail, email);
    if (localPhotoPath != null) {
      await sp.setString(_keyPhotoLocalPath, localPhotoPath);
    }
    if (remotePhotoUrl != null) {
      await sp.setString(_keyPhotoRemoteUrl, remotePhotoUrl);
    }
    await sp.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  Future<void> setUsername(String username) async {
    final sp = await _sp;
    await sp.setString(_keyUsername, username);
  }

  Future<void> setEmail(String email) async {
    final sp = await _sp;
    await sp.setString(_keyEmail, email);
  }

  /// Simpan path foto profil lokal (hasil pick dari galeri)
  Future<void> setLocalPhotoPath(String path) async {
    final sp = await _sp;
    await sp.setString(_keyPhotoLocalPath, path);
  }

  /// Simpan url foto di Firebase Storage
  Future<void> setRemotePhotoUrl(String url) async {
    final sp = await _sp;
    await sp.setString(_keyPhotoRemoteUrl, url);
  }

  Future<void> setIsLoggedIn(bool value) async {
    final sp = await _sp;
    await sp.setBool(_keyIsLoggedIn, value);
  }

  // ================== GETTER ==================

  Future<String?> getUserId() async {
    final sp = await _sp;
    return sp.getString(_keyUserId);
  }

  Future<String?> getUsername() async {
    final sp = await _sp;
    return sp.getString(_keyUsername);
  }

  Future<String?> getEmail() async {
    final sp = await _sp;
    return sp.getString(_keyEmail);
  }

  /// Path file foto lokal (dipakai untuk Image.file)
  Future<String?> getLocalPhotoPath() async {
    final sp = await _sp;
    return sp.getString(_keyPhotoLocalPath);
  }

  /// URL foto di Firebase Storage (fallback kalau lokal tidak ada)
  Future<String?> getRemotePhotoUrl() async {
    final sp = await _sp;
    return sp.getString(_keyPhotoRemoteUrl);
  }

  Future<bool> isLoggedIn() async {
    final sp = await _sp;
    return sp.getBool(_keyIsLoggedIn) ?? false;
  }

  // ================== CLEAR ==================

  /// Hapus semua data user (misal saat logout)
  Future<void> clearUser() async {
    final sp = await _sp;
    await sp.remove(_keyUserId);
    await sp.remove(_keyUsername);
    await sp.remove(_keyEmail);
    await sp.remove(_keyPhotoLocalPath);
    await sp.remove(_keyPhotoRemoteUrl);
    await sp.remove(_keyIsLoggedIn);
  }
}
