import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import '../design/templates/list_page_template.dart';
import '../design/organisms/product_list.dart';
import '../design/organisms/product_form.dart';
import '../design/organisms/delete_dialog.dart';
import '../design/templates/form_dialog_template.dart';

/// Página: Pantalla principal con lista de productos
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return ListPageTemplate(
          title: 'Productos',
          onAddPressed: () => _showProductFormDialog(context),
          body: ProductList(
            products: provider.products,
            onEdit: (product) => _showProductFormDialog(context, product: product),
            onDelete: (product) => _showDeleteDialog(context, product),
          ),
        );
      },
    );
  }

  void _showProductFormDialog(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (context) => FormDialogTemplate(
        title: product == null ? 'Agregar Producto' : 'Editar Producto',
        form: ProductForm(product: product),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(product: product),
    );
  }
}
