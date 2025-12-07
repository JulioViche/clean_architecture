import 'package:flutter/material.dart';

/// Átomo: Texto de precio formateado
class PriceText extends StatelessWidget {
  final double price;
  final double fontSize;
  final FontWeight fontWeight;

  const PriceText({
    super.key,
    required this.price,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.green.shade700,
      ),
    );
  }
}
