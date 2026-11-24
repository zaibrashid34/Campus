import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final TextEditingController _campusController = TextEditingController(text: 'Main Campus');
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String _selectedPickupLocation = AppConstants.campusLocations.first;
  String _selectedPaymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.currentUser?.fullName ?? '');
    _phoneController = TextEditingController(text: auth.currentUser?.phone ?? '');
    _buildingController.text = auth.currentUser?.preferredLocation ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _campusController.dispose();
    _buildingController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _onConfirmOrder() {
    if (_formKey.currentState!.validate()) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      final newOrder = orderProvider.placeOrder(
        cartItems: cartProvider.items,
        subtotal: cartProvider.subtotal,
        deliveryFee: cartProvider.deliveryFee,
        total: cartProvider.totalBill,
        customerName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        campusName: _campusController.text.trim(),
        buildingDepartment: _buildingController.text.trim(),
        pickupLocation: _selectedPickupLocation,
        instructions: _instructionsController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
      );

      // Clear Cart after successful order placement
      cartProvider.clearCart();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: newOrder),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Information Card
                const Text(
                  '1. Delivery & Contact Details',
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
                      CustomTextField(
                        label: 'Customer Full Name',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                        validator: AuthProvider.validateFullName,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: AuthProvider.validatePhone,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Campus Name',
                        controller: _campusController,
                        prefixIcon: Icons.school_outlined,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Building / Department / Room',
                        hint: 'e.g. CS Block 2, Lab 4',
                        controller: _buildingController,
                        prefixIcon: Icons.business_outlined,
                        validator: (v) => v == null || v.isEmpty ? 'Please specify building/department' : null,
                      ),
                      const SizedBox(height: 14),
                      // Dropdown for Pickup spot
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Campus Pickup Spot',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedPickupLocation,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: AppConstants.campusLocations
                                .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedPickupLocation = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Additional Delivery Instructions (Optional)',
                        hint: 'Call when reached, leave at reception...',
                        controller: _instructionsController,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Method
                const Text(
                  '2. Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          _selectedPaymentMethod == 'Cash on Delivery'
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: AppColors.primary,
                        ),
                        title: const Text('Cash on Delivery (COD)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Pay when food arrives at your campus location'),
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'Cash on Delivery';
                          });
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          _selectedPaymentMethod == 'Cash on Pickup'
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: AppColors.primary,
                        ),
                        title: const Text('Cash on Pickup (COP)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Pay at counter when picking up from cafeteria'),
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'Cash on Pickup';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Summary Card
                const Text(
                  '3. Order Summary',
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
                      ...cartProvider.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.foodItem.name}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  'PKR ${item.totalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle(color: AppColors.textMuted)),
                          Text('PKR ${cartProvider.subtotal.toStringAsFixed(0)}'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Fee', style: TextStyle(color: AppColors.textMuted)),
                          Text(cartProvider.deliveryFee == 0
                              ? 'FREE'
                              : 'PKR ${cartProvider.deliveryFee.toStringAsFixed(0)}'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Final Total',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'PKR ${cartProvider.totalBill.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Confirm Button
                CustomButton(
                  text: 'Confirm & Place Order',
                  icon: Icons.check_circle_outline,
                  onPressed: _onConfirmOrder,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
