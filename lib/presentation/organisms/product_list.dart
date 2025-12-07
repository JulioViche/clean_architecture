import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';
import 'empty_state.dart';

/// Organismo: Lista completa de productos
class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onEdit;
  final Function(Product) onDelete;

  const ProductList({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onEdit: () => onEdit(product),
          onDelete: () => onDelete(product),
        );
      },
    );
  }
}
