import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final String address;
  final String instructions;
  final String paymentMethod;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.address,
    required this.instructions,
    required this.paymentMethod,
    required this.createdAt,
  });

  double get total => subtotal + deliveryFee + serviceFee;
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}
