import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Order Management'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? const Center(child: Text('No orders placed yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final formattedDate =
                      DateFormat('dd MMM, hh:mm a').format(order.orderDate);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.statusText,
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Customer: ${order.customerName} (${order.phone})'),
                        Text('Pickup Spot: ${order.pickupLocation}'),
                        Text('Placed: $formattedDate',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        const Divider(height: 20),

                        // Ordered Items Summary
                        ...order.items.map((it) => Text('• ${it.quantity}x ${it.foodItem.name}')),
                        const SizedBox(height: 8),
                        Text(
                          'Total Bill: PKR ${order.total.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 14),

                        // Update Status Dropdown / Buttons
                        Row(
                          children: [
                            const Text('Update Status: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<OrderStatus>(
                                initialValue: order.status,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                items: OrderStatus.values
                                    .map((st) => DropdownMenuItem(
                                          value: st,
                                          child: Text(st.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
                                        ))
                                    .toList(),
                                onChanged: (newStatus) {
                                  if (newStatus != null) {
                                    orderProvider.updateOrderStatus(order.id, newStatus);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Order ${order.id} status updated!'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
