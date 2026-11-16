import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

/// User Profile & System Configuration Screen demonstrating session management,
/// theme switching, storage resets, and corporate brand info.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.corporate_fare_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(AppConstants.companyName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Sankar Commerce Hub',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 6),
            Text(
              'Built for the Sankar Group Flutter Development Internship Assignment.',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 12),
            Text('• Role: Flutter Developer Intern'),
            Text('• Framework: Flutter 3.47 / Dart 3.13'),
            Text('• State Management: Provider Architecture'),
            Text('• Storage: SharedPreferences (Persistent Auth & Cart)'),
            Text('• API: DummyJSON Public REST API + Offline Failover'),
            SizedBox(height: 12),
            Text(
              'Version 1.0.0 (Production Candidate)',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to end your current session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              final auth = Provider.of<AuthProvider>(context, listen: false);
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleResetStorage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Local Storage?'),
        content: const Text(
          'This will clear SharedPreferences (cart, wishlist, and session cache). Useful for demonstrating fresh app state.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await StorageService.instance.clearAll();
              if (context.mounted) {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final cart = Provider.of<CartProvider>(context, listen: false);
                final fav = Provider.of<FavoriteProvider>(context, listen: false);
                await auth.logout();
                await cart.clearCart();
                await fav.clearAll();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Reset All', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final productProv = Provider.of<ProductProvider>(context);
    final cartProv = Provider.of<CartProvider>(context);
    final favProv = Provider.of<FavoriteProvider>(context);

    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: isDark ? AppColors.secondary : AppColors.primary,
                      child: Text(
                        (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'S',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user?.name ?? 'Sankar Member',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? AppConstants.demoEmail,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              user?.role ?? 'Sankar Associate',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Preferences Section
            _buildSectionHeader('App Preferences'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Persistent theme saved in SharedPreferences', style: TextStyle(fontSize: 11.5)),
                    secondary: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: isDark ? AppColors.secondary : AppColors.primary,
                    ),
                    value: themeProv.isDarkMode,
                    onChanged: (val) => themeProv.toggleTheme(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Enabled for order status updates', style: TextStyle(fontSize: 11.5)),
                    trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // System Diagnostics & Architecture Section
            _buildSectionHeader('System & Integration Status'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      productProv.isOfflineMode ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                      color: productProv.isOfflineMode ? AppColors.warning : AppColors.success,
                    ),
                    title: const Text('Backend REST API', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      productProv.isOfflineMode
                          ? 'Offline Mode (Serving structured local Sankar catalog)'
                          : 'Live Public API Connected (DummyJSON REST Engine)',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                    trailing: TextButton(
                      onPressed: () => productProv.refresh(),
                      child: const Text('Sync', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage_rounded, color: AppColors.secondary),
                    title: const Text('Local Persistence', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'SharedPreferences • ${favProv.count} Wishlist • ${cartProv.totalItemCount} Cart',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Support & About Section
            _buildSectionHeader('About Sankar Group'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                    title: const Text('Assignment Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Architecture, packages & evaluation criteria', style: TextStyle(fontSize: 11.5)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_rounded, color: AppColors.warning),
                    title: const Text('Reset Local Storage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Wipes SharedPreferences to test clean install', style: TextStyle(fontSize: 11.5)),
                    onTap: () => _handleResetStorage(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            CustomButton(
              text: 'Sign Out',
              icon: Icons.logout_rounded,
              isOutlined: true,
              textColor: AppColors.error,
              onPressed: () => _handleLogout(context),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sankar Group • Flutter Developer Intern Assignment',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
