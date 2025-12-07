import '../repositories/product_repository.dart';
import '../entities/product.dart';

class UpdateProduct {
  final ProductRepository repository;
  
  UpdateProduct(this.repository);

  void call(Product product) => repository.updateProduct(product);
}