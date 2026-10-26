import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_providers.dart';
import '../constants/app_colors.dart';

const _navAccent = AppColors.primary;

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  void _go(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _item(IconData icon, IconData activeIcon, String label, int branch) {
    final selected = navigationShell.currentIndex == branch;
    final color = selected ? _navAccent : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => _go(branch),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider).length;

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 84,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  _item(Icons.home_rounded, Icons.home_rounded, 'Home', 0),
                  _item(Icons.grid_view_rounded, Icons.grid_view_rounded,
                      'Categories', 2),
                  const Expanded(child: SizedBox()),
                  _item(Icons.assignment_outlined, Icons.assignment_rounded,
                      'Orders', 1),
                  _item(Icons.person_outline_rounded, Icons.person_rounded,
                      'Profile', 3),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => context.push('/cart'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 14,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.shopping_basket_outlined,
                          size: 28, color: _navAccent),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Color(0xFFF5B301), shape: BoxShape.circle),
                          child: Text('$cartCount',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
