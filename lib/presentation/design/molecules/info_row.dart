import 'package:flutter/material.dart';
import '../atoms/label_text.dart';

/// Molécula: Fila de información (label + valor)
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LabelText(text: '$label: ', isBold: true),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
