import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/transaction_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      // Small delay for splash animation
      await Future.delayed(const Duration(seconds: 2));

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Changed from _loadAuthState() to loadAuthState()
      await authProvider.loadAuthState();

      // If logged in, initialize other providers
      if (authProvider.isLoggedIn) {
        await _initializeProviders();

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load app: $e';
      });
    }
  }

  Future<void> _initializeProviders() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      // Initialize providers in parallel
      await Future.wait([
        userProvider.fetchUsers(),
        categoryProvider.fetchTotalCategories(),
        transactionProvider.fetchTotalTransactions(),
      ]);
    } catch (e) {
      // Log error but continue to dashboard
      debugPrint('Failed to initialize providers: $e');
    }
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),

                // App Name
                Text(
                  'Budget Tracker',
                  style: AppStyles.headline1.copyWith(
                    color: AppColors.primary,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  'Admin Panel',
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Loading or Error State
                if (_hasError)
                  Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: AppStyles.bodyLarge.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      // Loading Animation
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              strokeWidth: 4,
                            ),
                            Icon(
                              Icons.admin_panel_settings,
                              color: AppColors.primary.withOpacity(0.7),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Loading Text with Dots Animation
                      _buildLoadingText(),
                      const SizedBox(height: 16),

                      // Loading Info
                      Text(
                        'Checking authentication...',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 40),

                // Footer
                Column(
                  children: [
                    const Divider(
                      color: AppColors.divider,
                      thickness: 1,
                      height: 40,
                    ),
                    Text(
                      'Secure Admin Access',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.security,
                          color: AppColors.success,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Protected System',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingText() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        final dotCount = (value * 3).floor();
        String dots = '';
        for (int i = 0; i < dotCount; i++) {
          dots += '.';
        }

        return Text(
          'Loading$dots',
          style: AppStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}