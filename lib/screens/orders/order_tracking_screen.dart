import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Track Order')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Track ${order.id}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID: ${order.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          order.statusText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Placed on $formattedDate',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tracking Stepper Card
              const Text(
                'Live Order Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildStepItem(
                      title: 'Order Placed',
                      subtitle: 'Your order has been sent to the cafeteria',
                      isCompleted: _isStepCompleted(order.status, 0),
                      isCurrent: _isStepCurrent(order.status, 0),
                    ),
                    _buildStepDivider(_isStepCompleted(order.status, 1)),
                    _buildStepItem(
                      title: 'Order Confirmed',
                      subtitle: 'Campus kitchen accepted your order',
                      isCompleted: _isStepCompleted(order.status, 1),
                      isCurrent: _isStepCurrent(order.status, 1),
                    ),
                    _buildStepDivider(_isStepCompleted(order.status, 2)),
                    _buildStepItem(
                      title: 'Preparing Food',
                      subtitle: 'Chefs are cooking your meal with care',
                      isCompleted: _isStepCompleted(order.status, 2),
                      isCurrent: _isStepCurrent(order.status, 2),
                    ),
                    _buildStepDivider(_isStepCompleted(order.status, 3)),
                    _buildStepItem(
                      title: 'Ready for Pickup / Out for Delivery',
                      subtitle: 'Food is on its way to ${order.pickupLocation}',
                      isCompleted: _isStepCompleted(order.status, 3),
                      isCurrent: _isStepCurrent(order.status, 3),
                    ),
                    _buildStepDivider(_isStepCompleted(order.status, 4)),
                    _buildStepItem(
                      title: 'Delivered',
                      subtitle: 'Enjoy your meal on campus!',
                      isCompleted: _isStepCompleted(order.status, 4),
                      isCurrent: _isStepCurrent(order.status, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Order Details Card
              const Text(
                'Delivery Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.person, 'Customer', order.customerName),
                    const Divider(),
                    _buildDetailRow(Icons.phone, 'Phone', order.phone),
                    const Divider(),
                    _buildDetailRow(Icons.school, 'Campus', order.campusName),
                    const Divider(),
                    _buildDetailRow(Icons.business, 'Building/Dept', order.buildingDepartment),
                    const Divider(),
                    _buildDetailRow(Icons.location_on, 'Pickup Spot', order.pickupLocation),
                    const Divider(),
                    _buildDetailRow(Icons.payments, 'Payment Method', order.paymentMethod),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Items summary
              const Text(
                'Items Ordered',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.foodItem.name}'),
                              Text(
                                'PKR ${item.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  bool _isStepCompleted(OrderStatus status, int stepIndex) {
    int currentStep = _getStatusIndex(status);
    return currentStep >= stepIndex;
  }

  bool _isStepCurrent(OrderStatus status, int stepIndex) {
    int currentStep = _getStatusIndex(status);
    return currentStep == stepIndex;
  }

  int _getStatusIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  Widget _buildStepItem({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    Color iconColor = isCompleted ? AppColors.successGreen : AppColors.textMuted;
    if (isCurrent) iconColor = AppColors.primary;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted
                ? Icons.check_circle
                : (isCurrent ? Icons.sync : Icons.radio_button_unchecked),
            color: iconColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isCompleted || isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted || isCurrent ? AppColors.textDark : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 19, top: 4, bottom: 4),
      height: 20,
      width: 2,
      color: isActive ? AppColors.successGreen : AppColors.borderGrey,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
