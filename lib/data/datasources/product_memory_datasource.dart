import '../../domain/entities/product.dart';

class ProductMemoryDatasource {
  final List<Product> _products = [];

  // Cargar toda la lista de productos
  List<Product> getAll() => _products;

  // Agregar un nuevo producto
  void add(Product product) => _products.add(product);

  // Actualizar un producto existente
  void update(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) _products[index] = product;
  }

  // Eliminar un producto por su ID
  void delete(String productId) {
    _products.removeWhere((p) => p.id == productId);
  }
}