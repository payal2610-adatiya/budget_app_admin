import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const Duration timeout = Duration(seconds: 30);

  // Helper method to handle responses
  static Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      return json.decode(response.body);
    } catch (e) {
      return {
        'code': 500,
        'message': 'Failed to parse response',
        'error': e.toString(),
      };
    }
  }

  // ============ ADMIN DASHBOARD STATS ============
  // In ApiService class
  static Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.adminStats),
      ).timeout(timeout);

      final data = _parseResponse(response);
      print('API Stats Response: $data'); // Debug log

      if (response.statusCode == 200 && data['code'] == 200) {
        return {
          'success': true,
          'total_users': data['total_users'] ?? 0,
          'total_categories': data['total_categories'] ?? 0,
          'total_transactions': data['total_transactions'] ?? 0,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to fetch stats',
      };
    } catch (e) {
      print('ApiService Error: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // ============ USER MANAGEMENT ============
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getUsers),
      ).timeout(timeout);

      final data = _parseResponse(response);

      if (response.statusCode == 200 && data['code'] == 200) {
        final List usersData = data['users'] ?? [];
        return usersData.map((item) => User.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.deleteUser),
        body: {'user_id': userId},
      ).timeout(timeout);

      final data = _parseResponse(response);
      return {
        'success': response.statusCode == 200 && data['code'] == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // ============ CATEGORIES ============
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getCategories),
      ).timeout(timeout);

      final data = _parseResponse(response);

      if (response.statusCode == 200 && data['code'] == 200) {
        final List categoriesData = data['categories'] ?? [];
        return categoriesData.map((item) => Category.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> addCategory(
      String userId,
      String name,
      String type,
      ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.addCategory),
        body: {
          'user_id': userId,
          'name': name,
          'type': type,
        },
      ).timeout(timeout);

      final data = _parseResponse(response);
      return {
        'success': response.statusCode == 200 && data['code'] == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.deleteCategory}?id=$categoryId'),
      ).timeout(timeout);

      final data = _parseResponse(response);
      return {
        'success': response.statusCode == 200 && data['code'] == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }


  // ============ TRANSACTIONS ============
  // In ApiService class
  static Future<Map<String, dynamic>> getTransactionStats() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.adminStats),
      ).timeout(timeout);

      final data = _parseResponse(response);

      if (response.statusCode == 200 && data['code'] == 200) {
        return {
          'success': true,
          'total_transactions': data['total_transactions'] ?? 0,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to fetch transaction stats',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

// Method to get transaction count by date range (if needed)
  static Future<Map<String, dynamic>> getTransactionCountByDate(
      String startDate,
      String endDate,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/transaction_count.php'),
        body: {
          'start_date': startDate,
          'end_date': endDate,
        },
      ).timeout(timeout);

      final data = _parseResponse(response);

      if (response.statusCode == 200 && data['code'] == 200) {
        return {
          'success': true,
          'count': data['count'] ?? 0,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to fetch transaction count',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}