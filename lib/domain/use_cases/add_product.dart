import '../repositories/product_repository.dart';
import '../entities/product.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  void call(Product product) => repository.addProduct(product);
}