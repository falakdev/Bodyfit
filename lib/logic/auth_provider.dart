import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('auth_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _email = savedEmail;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // Basic mock validation
    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid credentials');
    }
    _email = email;
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email);
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      throw Exception('Please fill all fields (password 6+ chars)');
    }
    _email = email;
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email);
    notifyListeners();
  }

  Future<void> logout() async {
    _email = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_email');
    notifyListeners();
  }
}


