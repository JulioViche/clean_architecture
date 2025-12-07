import '../datasources/product_memory_datasource.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl  implements ProductRepository {
  final ProductMemoryDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  List<Product> getProducts() => datasource.getAll();

  @override
  void addProduct(Product product) => datasource.add(product);

  @override
  void updateProduct(Product product) => datasource.update(product);

  @override
  void deleteProduct(String productId) => datasource.delete(productId);
}