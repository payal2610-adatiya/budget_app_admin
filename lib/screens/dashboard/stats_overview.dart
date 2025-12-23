import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/user_provider.dart';
import '../../providers/category_provider.dart';
import '../../data/services/api_service.dart';

class StatsOverview extends StatefulWidget {
  const StatsOverview({super.key});

  @override
  State<StatsOverview> createState() => _StatsOverviewState();
}

class _StatsOverviewState extends State<StatsOverview> {
  Map<String, dynamic> _stats = {
    'total_users': 0,
    'total_categories': 0,
    'total_transactions': 0,
  };
  bool _isLoading = false;

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
    });

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

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statistics Overview',
                style: AppStyles.headline3.copyWith(fontSize: 18),
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: _loadStats,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Users',
                    _stats['total_users'].toString(),
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Active Users',
                    userProvider.activeUsersCount.toString(),
                    Icons.person_rounded,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Categories',
                  _stats['total_categories'].toString(),
                  Icons.category,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Transactions',
                  _stats['total_transactions'].toString(),
                  Icons.receipt_long,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(
                value,
                style: AppStyles.numberMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}