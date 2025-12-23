import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  final VoidCallback onStatusChanged;
  final VoidCallback onDelete;

  const UserDetailScreen({
    super.key,
    required this.user,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit user functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: AppStyles.headline1.copyWith(
                          color: AppColors.primary,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: AppStyles.headline2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: user.isActive
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.isActive ? 'Active User' : 'Inactive User',
                      style: AppStyles.bodyMedium.copyWith(
                        color: user.isActive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // User Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Information',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem('User ID', user.id),
                  const Divider(height: 20),
                  _buildInfoItem('Email Address', user.email),
                  const Divider(height: 20),
                  _buildInfoItem(
                    'Account Created',
                    DateFormat('dd MMMM yyyy').format(user.createdAt),
                  ),
                  const Divider(height: 20),
                  _buildInfoItem(
                    'Member For',
                    _calculateTimeSince(user.createdAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Statistics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Categories', '12', Icons.category),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('Transactions', '45', Icons.receipt_long),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actions',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: user.isActive ? 'Deactivate User' : 'Activate User',
                    onPressed: onStatusChanged,
                    backgroundColor: user.isActive ? AppColors.warning : AppColors.success,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Send Message',
                    onPressed: () {
                      // Send message functionality
                    },
                    //isOutlined: true,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Delete User',
                    onPressed: onDelete,
                    backgroundColor: AppColors.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: AppStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: AppColors.primary, size: 16),
              ),
              const Spacer(),
              Text(
                value,
                style: AppStyles.numberMedium,
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

  String _calculateTimeSince(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Today';
    }
  }
}