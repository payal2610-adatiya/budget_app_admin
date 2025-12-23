import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/dialogs.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoSyncEnabled = true;
  String _selectedTheme = 'light';

  @override
  void initState() {
    super.initState();
    // Load settings from preferences
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load from shared preferences here
    // For now, using default values
    setState(() {
      _notificationsEnabled = true;
      _autoSyncEnabled = true;
      _selectedTheme = 'light';
    });
  }

  Future<void> _saveSettings() async {
    // Save to shared preferences here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _clearCache() async {
    final confirmed = await Dialogs.showConfirmationDialog(
      context: context,
      title: 'Clear Cache',
      message: 'Are you sure you want to clear all cached data?',
    );

    if (confirmed) {
      // Clear cache logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache cleared successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _exportData() {
    // Export data logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _aboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Budget Tracker Admin'),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Manage and monitor user activities, categories, and transactions.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Account Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      authProvider.adminEmail,
                      style: AppStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text('Administrator'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Preferences Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive alerts and updates'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Auto Sync'),
                    subtitle: const Text('Automatically sync data'),
                    value: _autoSyncEnabled,
                    onChanged: (value) {
                      setState(() {
                        _autoSyncEnabled = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: const Text('Choose app theme'),
                    trailing: DropdownButton<String>(
                      value: _selectedTheme,
                      items: const [
                        DropdownMenuItem(
                          value: 'light',
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: 'dark',
                          child: Text('Dark'),
                        ),
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTheme = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Data Management Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Management',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: AppColors.error),
                    title: const Text('Clear Cache'),
                    subtitle: const Text('Remove all cached data'),
                    onTap: _clearCache,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                    title: const Text('Export Data'),
                    subtitle: const Text('Download reports and data'),
                    onTap: _exportData,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // About Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: AppStyles.headline3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primary),
                    title: const Text('About App'),
                    onTap: _aboutApp,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                    title: const Text('Privacy Policy'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                    title: const Text('Terms of Service'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Save Button
            CustomButton(
              text: 'Save Settings',
              onPressed: _saveSettings,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}