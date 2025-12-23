class ApiEndpoints {
  static const String baseUrl = 'https://prakrutitech.xyz/payal';

  static const String adminLogin = '$baseUrl/admin_api.php';

  // User Management
  static const String getUsers = '$baseUrl/view_user.php';
  static const String deleteUser = '$baseUrl/delete_user.php';

  // Categories (admin can add global categories)
  static const String getCategories = '$baseUrl/view_category.php';
  static const String addCategory = '$baseUrl/add_category.php';
  static const String updateCategory = '$baseUrl/update.php?action=update_category';
  static const String deleteCategory = '$baseUrl/delete_category.php';

  // Transactions
  static const String getTransactions = '$baseUrl/view_transaction.php';

  // Admin Dashboard Stats
  static const String adminStats = '$baseUrl/admin_api.php';
}