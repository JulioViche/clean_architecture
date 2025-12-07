import 'package:flutter/cupertino.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/add_product.dart';
import '../../domain/use_cases/delete_product.dart';
import '../../domain/use_cases/get_products.dart';
import '../../domain/use_cases/update_product.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final UpdateProduct updateProductUseCase;
  final DeleteProduct deleteProductUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  });

  List<Product> get products => getProductsUseCase();

  void add(product) {
    addProductUseCase(product);
    notifyListeners();
  }

  void update(product) {
    updateProductUseCase(product);
    notifyListeners();
  }

  void delete(productId) {
    deleteProductUseCase(productId);
    notifyListeners();
  }
}