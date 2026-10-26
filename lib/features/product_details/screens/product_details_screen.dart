import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product.dart';
import '../../../providers/app_providers.dart';
import '../../cart/widgets/checkout_widgets.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final Product product;
  
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isFavorite = ref.watch(favoriteProvider).contains(product.id);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              ref.read(favoriteProvider.notifier).toggleFavorite(product.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: theme.textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(product.unit, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${product.price.toStringAsFixed(2)}', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Product Details', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(product.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
            ),
            child: SafeArea(
              top: false,
              child: PillButton(
                label: 'Add to Cart',
                onPressed: () {
                  cartNotifier.addToCart(product);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text('${product.name} added to cart'),
                      action: SnackBarAction(
                        label: 'View cart',
                        textColor: AppColors.primarySoft,
                        onPressed: () => context.push('/cart'),
                      ),
                    ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
