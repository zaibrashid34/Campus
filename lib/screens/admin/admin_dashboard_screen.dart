import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/order_provider.dart';
import '../auth/login_screen.dart';
import 'admin_food_management_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_users_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final totalFoodItems = foodProvider.allFoodItems.length;
    final totalOrders = orderProvider.orders.length;
    final pendingOrders = orderProvider.activeOrders.length;
    final completedOrders = orderProvider.pastOrders.length;
    const totalUsers = 48; // Mock registered users count

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Header Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, Color(0xFF1B4332)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 26,
                      child: Icon(Icons.security, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.currentUser?.fullName ?? 'System Admin',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Campus Cafeteria Control Panel',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Overview Stats Grid
              const Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard(
                    title: 'Total Orders',
                    value: '$totalOrders',
                    icon: Icons.receipt_long,
                    color: AppColors.primary,
                  ),
                  _buildStatCard(
                    title: 'Pending Orders',
                    value: '$pendingOrders',
                    icon: Icons.pending_actions,
                    color: AppColors.warningOrange,
                  ),
                  _buildStatCard(
                    title: 'Completed',
                    value: '$completedOrders',
                    icon: Icons.task_alt,
                    color: AppColors.successGreen,
                  ),
                  _buildStatCard(
                    title: 'Food Items',
                    value: '$totalFoodItems',
                    icon: Icons.restaurant_menu,
                    color: AppColors.secondary,
                  ),
                  _buildStatCard(
                    title: 'Registered Users',
                    value: '$totalUsers',
                    icon: Icons.people_alt_outlined,
                    color: const Color(0xFF9C27B0),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Management Modules Section
              const Text(
                'Admin Management Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _buildManagementTile(
                context,
                title: 'Food Menu Management',
                subtitle: 'Add, Edit, Delete items, manage prices & availability',
                icon: Icons.fastfood_outlined,
                color: AppColors.primary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminFoodManagementScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildManagementTile(
                context,
                title: 'Order Status & Fulfillment',
                subtitle: 'Accept/Reject orders and update status (Preparing, Ready, Delivered)',
                icon: Icons.alt_route,
                color: AppColors.secondary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildManagementTile(
                context,
                title: 'User Account Management',
                subtitle: 'View registered students/staff and manage account status',
                icon: Icons.manage_accounts_outlined,
                color: const Color(0xFF9C27B0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminUsersScreen()),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              Icon(icon, color: color, size: 22),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
