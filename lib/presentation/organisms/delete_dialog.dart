import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

/// Organismo: Diálogo de confirmación para eliminar
class DeleteDialog extends StatelessWidget {
  final Product product;

  const DeleteDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: Text('¿Estás seguro de eliminar "${product.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            context.read<ProductProvider>().delete(product.id);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} eliminado'),
                backgroundColor: Colors.red,
              ),
            );
          },
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
