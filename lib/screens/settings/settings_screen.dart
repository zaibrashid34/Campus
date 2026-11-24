import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader('Account'),
            _buildCardTile(
              leadingIcon: Icons.edit_outlined,
              title: 'Edit Profile Information',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Preferences & Audio'),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive live order status updates & offers'),
                    secondary: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                    value: settings.notificationsEnabled,
                    onChanged: (val) => settings.toggleNotifications(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    title: const Text('Sound Effects'),
                    subtitle: const Text('Play sound on order status change'),
                    secondary: const Icon(Icons.volume_up_outlined, color: AppColors.primary),
                    value: settings.soundEnabled,
                    onChanged: (val) => settings.toggleSound(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    title: const Text('Vibration'),
                    subtitle: const Text('Vibrate device on food ready alert'),
                    secondary: const Icon(Icons.vibration, color: AppColors.primary),
                    value: settings.vibrationEnabled,
                    onChanged: (val) => settings.toggleVibration(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Accessibility'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Text Font Size',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      Text(
                        '${settings.fontSize.toInt()} pt',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    activeColor: AppColors.primary,
                    min: 12.0,
                    max: 20.0,
                    divisions: 4,
                    value: settings.fontSize,
                    onChanged: (val) => settings.setFontSize(val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Screen Reader Support'),
                    subtitle: const Text('Enable voiceover accessibility labels'),
                    secondary: const Icon(Icons.accessibility_new, color: AppColors.primary),
                    value: settings.screenReaderSupport,
                    onChanged: (val) => settings.toggleScreenReaderSupport(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('App Info & Support'),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  _buildListTileItem(
                    icon: Icons.help_outline,
                    title: 'Onboarding / How to Use',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTileItem(
                    icon: Icons.info_outline,
                    title: 'About ${AppConstants.appName}',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'Copyright © 2026 Campus Bites.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTileItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      _showPolicyDialog(
                        context,
                        'Privacy Policy',
                        'Campus Bites respects student privacy. We collect minimal location and contact information necessary solely for campus food order fulfillment. Password & credential authentication is securely managed.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTileItem(
                    icon: Icons.description_outlined,
                    title: 'Terms and Conditions',
                    onTap: () {
                      _showPolicyDialog(
                        context,
                        'Terms & Conditions',
                        'By using Campus Bites, you agree to pickup or receive orders placed at designated campus locations. All payments are cash on delivery/pickup in PKR.',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: const Icon(Icons.logout, color: AppColors.errorRed),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                authProvider.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildCardTile({
    required IconData leadingIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        leading: Icon(leadingIcon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }

  Widget _buildListTileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  void _showPolicyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
