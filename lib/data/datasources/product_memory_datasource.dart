import '../../domain/entities/product.dart';

class ProductMemoryDatasource {
  final List<Product> _products = [];
  int _nextId = 1;

  // Generar ID automático con formato PRO-XXX
  String _generateId() {
    final id = 'PRO-${_nextId.toString().padLeft(3, '0')}';
    _nextId++;
    return id;
  }

  // Cargar toda la lista de productos
  List<Product> getAll() => _products;

  // Agregar un nuevo producto con ID autogenerado
  void add(Product product) {
    final newProduct = Product(
      id: _generateId(),
      name: product.name,
      price: product.price,
    );
    _products.add(newProduct);
  }

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