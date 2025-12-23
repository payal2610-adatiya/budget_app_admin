import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/services/api_service.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';

  List<User> get users => _filteredUsers;
  List<User> get allUsers => _users;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get activeUsersCount => _users.where((user) => user.isActive).length;
  int get inactiveUsersCount => _users.where((user) => !user.isActive).length;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final users = await ApiService.getUsers();
      _users = users;
      _filteredUsers = users;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch users: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.deleteUser(userId);

      if (result['success'] == true) {
        _users.removeWhere((user) => user.id == userId);
        _filteredUsers = _users;
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchUsers(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void toggleUserStatus(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = _users[index].copyWith(
        isActive: !_users[index].isActive,
      );
      _filteredUsers = _users;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}