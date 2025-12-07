import '../entities/product.dart';

abstract class ProductRepository {
  List<Product> getProducts();
  void addProduct(Product product);
  void updateProduct(Product product);
  void deleteProduct(String productId);
}

/*
  NOTES:
  Un contrato se representa como clase abstracta en Dart.
*/