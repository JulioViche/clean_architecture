import 'package:flutter/material.dart';

/// Átomo: Texto de etiqueta
class LabelText extends StatelessWidget {
  final String text;
  final bool isBold;
  final double fontSize;
  final Color? color;

  const LabelText({
    super.key,
    required this.text,
    this.isBold = false,
    this.fontSize = 14,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color ?? Colors.grey.shade600,
      ),
    );
  }
}
