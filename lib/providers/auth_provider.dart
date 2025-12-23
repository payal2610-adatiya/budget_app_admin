import 'package:flutter/material.dart';
import '../data/services/shared_preference.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _adminEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get adminEmail => _adminEmail;

  AuthProvider() {
    loadAuthState();
  }

  // Changed from private to public method
  Future<void> loadAuthState() async {
    _isLoggedIn = SharedPrefs.getAdminLoggedIn();
    _adminEmail = SharedPrefs.getAdminEmail();
    notifyListeners();
  }

  // Custom admin login (no API, handled locally)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // Simple admin validation (you can enhance this)
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@budget.com' && password == 'admin123') {
      _isLoggedIn = true;
      _adminEmail = email;
      await SharedPrefs.setAdminLoggedIn(true);
      await SharedPrefs.setAdminEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid admin credentials';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await SharedPrefs.clearAll();
    _isLoggedIn = false;
    _adminEmail = '';
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}