import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/stat_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../data/services/api_service.dart';
import '../users/users_list_screen.dart';
import '../transactions/transactions_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _stats = {
    'total_users': 0,
    'total_categories': 0,
    'total_transactions': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    final userProvider = context.read<UserProvider>();
    final transactionProvider = context.read<TransactionProvider>();

    await userProvider.fetchUsers();
    await transactionProvider.fetchTotalTransactions();

    final statsResult = await ApiService.getAdminStats();
    if (statsResult['success'] == true) {
      setState(() {
        _stats = {
          'total_users': statsResult['total_users'] ?? 0,
          'total_categories': statsResult['total_categories'] ?? 0,
          'total_transactions': statsResult['total_transactions'] ?? 0,
        };
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppStyles.adminCardDecoration,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Admin!',
                            style: AppStyles.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            authProvider.adminEmail,
                            style: AppStyles.headline3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                            style: AppStyles.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Loading State
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    // Stats Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        StatCard(
                          title: 'Total Users', // Fixed: Removed extra space
                          value: _stats['total_users'].toString(),
                          icon: Icons.people,
                          color: AppColors.primary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UsersListScreen(),
                              ),
                            );
                          },
                        ),
                        StatCard(
                          title: 'Total Categories',
                          value: _stats['total_categories'].toString(),
                          icon: Icons.category,
                          color: AppColors.warning,
                          onTap: null,
                        ),
                        StatCard(
                          title: 'Total Transactions',
                          value: _stats['total_transactions'].toString(),
                          icon: Icons.receipt_long,
                          color: AppColors.error,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TransactionsScreen(),
                              ),
                            );
                          },
                        ),
                        StatCard(
                          title: 'Active Users',
                          value: userProvider.activeUsersCount.toString(),
                          icon: Icons.person,
                          color: AppColors.success,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UsersListScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions - ADDED BACK
                    Text(
                      'Quick Actions',
                      style: AppStyles.headline3,
                    ),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 24),

                    // Recent Users - ADDED BACK
                    _buildRecentUsers(userProvider),
                    const SizedBox(height: 24),

                    // System Info - ADDED BACK
                    _buildSystemInfo(),
                    const SizedBox(height: 24),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(
          icon: Icons.people_alt,
          label: 'Manage Users',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UsersListScreen(),
              ),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.bar_chart,
          label: 'View Stats',
          onTap: _showStatsDialog,
        ),
        _buildActionButton(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            // Navigate to settings if you have a settings screen
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppStyles.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUsers(UserProvider userProvider) {
    final recentUsers = userProvider.users.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Users',
                style: AppStyles.headline3.copyWith(fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UsersListScreen(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentUsers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No users found')),
            )
          else
            ...recentUsers.map((user) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.divider)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: AppStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.email,
                            style: AppStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.isActive ? 'Active' : 'Inactive',
                        style: AppStyles.bodySmall.copyWith(
                          color: user.isActive ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildSystemInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Information',
            style: AppStyles.headline3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Database', 'Connected', Icons.storage),
          const SizedBox(height: 12),
          _buildInfoItem('API Status', 'Online', Icons.cloud_done),
          const SizedBox(height: 12),
          _buildInfoItem('Last Sync', DateFormat('hh:mm a').format(DateTime.now()), Icons.sync),
          const SizedBox(height: 12),
          _buildInfoItem('Total Data', '${_stats['total_users'] + _stats['total_categories'] + _stats['total_transactions']} Records', Icons.data_usage),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Statistics'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Total Users', _stats['total_users'].toString()),
              const SizedBox(height: 8),
              _buildStatRow('Total Categories', _stats['total_categories'].toString()),
              const SizedBox(height: 8),
              _buildStatRow('Total Transactions', _stats['total_transactions'].toString()),
              const SizedBox(height: 8),
              _buildStatRow('Active Users', context.read<UserProvider>().activeUsersCount.toString()),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Last Updated: ${DateFormat('hh:mm:ss a').format(DateTime.now())}',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadDashboardData();
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}