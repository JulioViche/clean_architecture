import 'package:flutter/material.dart';
import '../atoms/product_icon.dart';
import '../atoms/label_text.dart';
import '../atoms/price_text.dart';

/// Molécula: Información del producto (icono + detalles)
class ProductInfo extends StatelessWidget {
  final String id;
  final String name;
  final double price;

  const ProductInfo({
    super.key,
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProductIcon(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              LabelText(text: 'ID: $id', fontSize: 12),
              const SizedBox(height: 4),
              PriceText(price: price),
            ],
          ),
        ),
      ],
    );
  }
}
