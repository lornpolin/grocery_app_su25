import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/order.dart';
import '../../../providers/app_providers.dart';
import '../../cart/widgets/checkout_widgets.dart';

const _ordersBg = Color(0xFFF8FAFC);
const _ordersTitle = Color(0xFF0F172A);
const _ordersMuted = Color(0xFF64748B);

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: _ordersBg,
      appBar: AppBar(
        backgroundColor: _ordersBg,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'My Orders',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: _ordersTitle),
        ),
      ),
      body: orders.isEmpty
          ? const _EmptyOrders()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  String _date(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${m[d.month - 1]} ${d.year}, $h:$min ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    final names = order.items.map((i) => '${i.quantity}× ${i.product.name}').join(', ');

    return CheckoutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Order #${order.id}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: _ordersTitle)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Processing',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(_date(order.createdAt),
              style: const TextStyle(fontSize: 12, color: _ordersMuted)),
          const Divider(height: 22, color: CheckoutColors.line),
          Text(names,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, height: 1.4, color: CheckoutColors.label)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: _ordersMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(order.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: _ordersMuted)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('${order.itemCount} item${order.itemCount == 1 ? '' : 's'} · ${order.paymentMethod}',
                  style: const TextStyle(fontSize: 13, color: _ordersMuted)),
              const Spacer(),
              Text(money(order.total),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 96),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'No orders yet',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: _ordersTitle),
            ),
            const SizedBox(height: 8),
            const Text(
              'When you place an order, it will show up here so you can track it.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: _ordersMuted),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 200,
              child: PillButton(
                label: 'Start shopping',
                onPressed: () => context.go('/home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
