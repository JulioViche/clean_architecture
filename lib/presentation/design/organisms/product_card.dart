import 'package:flutter/material.dart';
import '../../../../domain/entities/product.dart';
import '../molecules/product_info.dart';
import '../molecules/action_buttons.dart';

/// Organismo: Card de producto individual
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ProductInfo(
                id: product.id,
                name: product.name,
                price: product.price,
              ),
            ),
            ActionButtons(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
