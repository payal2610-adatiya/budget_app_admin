// lib/screens/transactions/transactions_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/stat_card.dart';
import '../../providers/transaction_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TransactionProvider>().fetchTotalTransactions();
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          // Fetch data on first load
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (transactionProvider.totalTransactions == 0 &&
                !transactionProvider.isLoading) {
              transactionProvider.fetchTotalTransactions();
            }
          });

          return RefreshIndicator(
            onRefresh: () => transactionProvider.fetchTotalTransactions(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Statistics Card
                  StatCard(
                    title: 'Total Transactions',
                    value: transactionProvider.totalTransactions.toString(),
                    icon: Icons.receipt_long,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),

                  // Information Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppStyles.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Statistics',
                          style: AppStyles.headline3,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Total Transaction Count',
                          transactionProvider.totalTransactions.toString(),
                          Icons.numbers,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Data Privacy',
                          'Admin view: Count only',
                          Icons.privacy_tip,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Last Updated',
                          'Live database count',
                          Icons.update,
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: AppColors.divider,
                          height: 1,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'About Transaction Data',
                          style: AppStyles.headline3.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'For privacy reasons, administrators can only view the total number of transactions. Individual transaction details are only accessible to the respective users.',
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Loading State
                  if (transactionProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // Error State
                  if (transactionProvider.errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.error),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              transactionProvider.errorMessage,
                              style: AppStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => transactionProvider.fetchTotalTransactions(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Count'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Show information about the system
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Transaction System'),
                                content: const Text(
                                    'The transaction count is fetched directly from the database. '
                                        'It represents the total number of financial transactions recorded '
                                        'by all users in the system.'
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Learn More'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
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
      ),
    );
  }
}