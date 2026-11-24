import '../utils/encryption_helper.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled
}

class OrderModel {
  final String id;
  final DateTime orderDate;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final String customerName;
  final String phone;
  final String campusName;
  final String buildingDepartment;
  final String pickupLocation;
  final String instructions;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.customerName,
    required this.phone,
    required this.campusName,
    required this.buildingDepartment,
    required this.pickupLocation,
    this.instructions = '',
    this.paymentMethod = 'Cash on Delivery',
  });

  String get statusText {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Food';
      case OrderStatus.ready:
        return 'Ready for Pickup / Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Converts OrderModel to a Map for Firebase / Database storage with encryption on sensitive fields
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.index,
      'customerName': customerName,
      'phone': EncryptionHelper.encryptData(phone), // Encrypted before DB storage
      'campusName': campusName,
      'buildingDepartment': buildingDepartment,
      'pickupLocation': pickupLocation,
      'instructions': EncryptionHelper.encryptData(instructions), // Encrypted before DB storage
      'paymentMethod': paymentMethod,
    };
  }

  /// Creates OrderModel from Database Map with decryption on sensitive fields
  factory OrderModel.fromMap(Map<String, dynamic> map, List<CartItemModel> items) {
    return OrderModel(
      id: map['id'] ?? '',
      orderDate: map['orderDate'] != null ? DateTime.parse(map['orderDate']) : DateTime.now(),
      items: items,
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      status: OrderStatus.values[map['status'] ?? 0],
      customerName: map['customerName'] ?? '',
      phone: EncryptionHelper.decryptData(map['phone'] ?? ''), // Decrypted when using in app
      campusName: map['campusName'] ?? '',
      buildingDepartment: map['buildingDepartment'] ?? '',
      pickupLocation: map['pickupLocation'] ?? '',
      instructions: EncryptionHelper.decryptData(map['instructions'] ?? ''), // Decrypted when using in app
      paymentMethod: map['paymentMethod'] ?? 'Cash on Delivery',
    );
  }

  OrderModel copyWith({
    String? id,
    DateTime? orderDate,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    OrderStatus? status,
    String? customerName,
    String? phone,
    String? campusName,
    String? buildingDepartment,
    String? pickupLocation,
    String? instructions,
    String? paymentMethod,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      campusName: campusName ?? this.campusName,
      buildingDepartment: buildingDepartment ?? this.buildingDepartment,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      instructions: instructions ?? this.instructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
