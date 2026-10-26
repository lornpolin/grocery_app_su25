import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/mock_data.dart';

const String _kCartKey = 'cart_items';
const String _kFavoritesKey = 'favorite_ids';

/// Flat fees applied at checkout.
const double kDeliveryFee = 5.0;
const double kServiceFee = 0.15;

final productsProvider = Provider<List<Product>>((ref) {
  return MockData.products;
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _load();
  }

  /// Restores the persisted cart (stored as {productId: quantity}).
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCartKey);
    if (raw == null) return;
    try {
      final saved = (jsonDecode(raw) as Map<String, dynamic>);
      final restored = <CartItem>[];
      for (final product in MockData.products) {
        final qty = saved[product.id];
        if (qty is int && qty > 0) {
          restored.add(CartItem(id: product.id, product: product, quantity: qty));
        }
      }
      // Keep anything the user added while loading.
      final merged = [...restored];
      for (final item in state) {
        final i = merged.indexWhere((e) => e.product.id == item.product.id);
        if (i >= 0) {
          merged[i] = merged[i].copyWith(quantity: merged[i].quantity + item.quantity);
        } else {
          merged.add(item);
        }
      }
      state = merged;
    } catch (_) {
      await prefs.remove(_kCartKey);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kCartKey,
      jsonEncode({for (final i in state) i.product.id: i.quantity}),
    );
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      final updatedItem = state[existingItemIndex].copyWith(
        quantity: state[existingItemIndex].quantity + quantity,
      );
      final newState = [...state];
      newState[existingItemIndex] = updatedItem;
      state = newState;
    } else {
      state = [...state, CartItem(id: DateTime.now().toString(), product: product, quantity: quantity)];
    }
    _save();
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _save();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final existingItemIndex = state.indexWhere((item) => item.product.id == productId);
    if (existingItemIndex >= 0) {
      final updatedItem = state[existingItemIndex].copyWith(quantity: quantity);
      final newState = [...state];
      newState[existingItemIndex] = updatedItem;
      state = newState;
      _save();
    }
  }
  
  void clearCart() {
    state = [];
    _save();
  }
  
  double get totalAmount {
    return state.fold(0, (sum, item) => sum + item.subtotal);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

/// Reactive cart total; rebuilds watchers whenever the cart changes.
final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<double>(0, (sum, item) => sum + item.subtotal);
});

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kFavoritesKey) ?? const [];
    state = {...saved, ...state}.toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, state);
  }

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
    _save();
  }
  
  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier();
});

/// Placed orders (in-memory, newest first).
class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super(const []);

  void add(Order order) => state = [order, ...state];
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});
