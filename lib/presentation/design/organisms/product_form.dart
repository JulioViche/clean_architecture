import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/product.dart';
import '../../providers/product_provider.dart';
import '../molecules/form_text_field.dart';
import '../atoms/custom_button.dart';

/// Organismo: Formulario de producto (crear/editar)
class ProductForm extends StatefulWidget {
  final Product? product;

  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.product?.id ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormTextField(
            controller: _idController,
            label: 'ID',
            icon: Icons.tag,
            enabled: !isEditing,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El ID es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FormTextField(
            controller: _nameController,
            label: 'Nombre',
            icon: Icons.shopping_bag,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FormTextField(
            controller: _priceController,
            label: 'Precio',
            icon: Icons.attach_money,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El precio es obligatorio';
              }
              final price = double.tryParse(value);
              if (price == null) {
                return 'Ingresa un precio válido';
              }
              if (price <= 0) {
                return 'El precio debe ser mayor a 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              CustomButton(
                text: isEditing ? 'Actualizar' : 'Guardar',
                onPressed: _saveProduct,
                icon: isEditing ? Icons.check : Icons.add,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
      );

      final provider = context.read<ProductProvider>();

      if (isEditing) {
        provider.update(product);
        _showSnackBar(context, '${product.name} actualizado', Colors.green);
      } else {
        provider.add(product);
        _showSnackBar(context, '${product.name} agregado', Colors.blue);
      }

      Navigator.pop(context);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
