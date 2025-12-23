import 'package:flutter/material.dart';
import '../data/services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  int _totalCategories = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  int get totalCategories => _totalCategories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchTotalCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final statsResult = await ApiService.getAdminStats();

      if (statsResult['success'] == true) {
        _totalCategories = statsResult['total_categories'] ?? 0;
      } else {
        _errorMessage = statsResult['message'] ?? 'Failed to fetch categories count';
        _totalCategories = 0;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      _totalCategories = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}