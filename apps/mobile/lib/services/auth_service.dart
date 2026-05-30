import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola JWT token secara lokal.
/// Token disimpan di SharedPreferences agar persist antar sesi.
class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _usernameKey = 'username';

  /// Simpan token JWT dan username setelah login berhasil.
  static Future<void> saveSession(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  /// Ambil token JWT yang tersimpan.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Ambil username yang tersimpan.
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Cek apakah user sudah login (token ada).
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Hapus token dan username (logout).
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }
}
