// lib/providers/transaction_provider.dart
import 'package:flutter/material.dart';
import '../data/services/api_service.dart';

class TransactionProvider extends ChangeNotifier {
  int _totalTransactions = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  int get totalTransactions => _totalTransactions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get totalTransactionCount => _totalTransactions; // Fixed: Now returns the actual count

  Future<void> fetchTotalTransactions() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final statsResult = await ApiService.getAdminStats();

      if (statsResult['success'] == true) {
        _totalTransactions = statsResult['total_transactions'] ?? 0;
        print('DEBUG: Fetched transactions: $_totalTransactions');
      } else {
        _errorMessage = statsResult['message'] ?? 'Failed to fetch transaction count';
        _totalTransactions = 0;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      _totalTransactions = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}