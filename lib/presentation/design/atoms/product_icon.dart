import 'package:flutter/material.dart';

/// Átomo: Icono de producto con contenedor decorado
class ProductIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const ProductIcon({
    super.key,
    this.icon = Icons.shopping_bag,
    this.size = 32,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: iconColor ?? Colors.blue.shade700,
        size: size,
      ),
    );
  }
}
