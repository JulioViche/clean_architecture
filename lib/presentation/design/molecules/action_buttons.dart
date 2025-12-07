import 'package:flutter/material.dart';
import '../atoms/custom_icon_button.dart';

/// Molécula: Botones de acción (editar y eliminar)
class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          icon: Icons.edit,
          onPressed: onEdit,
          color: Colors.blue,
          tooltip: 'Editar',
        ),
        CustomIconButton(
          icon: Icons.delete,
          onPressed: onDelete,
          color: Colors.red,
          tooltip: 'Eliminar',
        ),
      ],
    );
  }
}
