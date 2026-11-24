import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final activeOrders = orderProvider.activeOrders;
    final pastOrders = orderProvider.pastOrders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Orders'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Active Orders'),
              Tab(text: 'Order History'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _buildOrderList(context, activeOrders, isActive: true),
              _buildOrderList(context, pastOrders, isActive: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderModel> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.pending_actions : Icons.history,
              size: 64,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No Active Orders' : 'No Order History',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'Your active campus food orders will appear here.'
                  : 'Past orders will be archived here.',
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID & Status Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    _buildStatusChip(order.status, order.statusText),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(),
                ),

                // Item count & preview
                ...order.items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.quantity}x ${item.foodItem.name}',
                            style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                          ),
                          Text(
                            'PKR ${item.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                if (order.items.length > 3)
                  Text(
                    '+ ${order.items.length - 3} more items',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(),
                ),

                // Total & Track Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Bill',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        Text(
                          'PKR ${order.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrderTrackingScreen(orderId: order.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.alt_route, size: 16),
                      label: const Text('Track Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(OrderStatus status, String text) {
    Color bg = AppColors.statusPlaced;
    switch (status) {
      case OrderStatus.placed:
        bg = AppColors.statusPlaced;
        break;
      case OrderStatus.confirmed:
        bg = AppColors.statusConfirmed;
        break;
      case OrderStatus.preparing:
        bg = AppColors.statusPreparing;
        break;
      case OrderStatus.ready:
        bg = AppColors.statusReady;
        break;
      case OrderStatus.delivered:
        bg = AppColors.statusDelivered;
        break;
      case OrderStatus.cancelled:
        bg = AppColors.errorRed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: bg,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
