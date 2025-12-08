# Capa Data - Documentación Técnica

La capa **Data** implementa los contratos del Domain y gestiona el acceso a las fuentes de datos.

## Estructura

```
data/
├── datasources/
│   └── product_memory_datasource.dart
└── repositories/
    └── product_repository_impl.dart
```

---

## DataSources

### `product_memory_datasource.dart`

```dart
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
```

#### Propósito

Gestiona el almacenamiento de productos en memoria RAM durante la ejecución de la app. Genera IDs automáticos con formato PRO-XXX y ejecuta operaciones CRUD.

#### Interacciones

**Usa:**
- `domain/entities/product.dart`

**Usado por:**
- `data/repositories/product_repository_impl.dart`

#### Descripción del Código

**Atributos:**
- `_products`: Lista privada que almacena productos en memoria (se pierden al cerrar la app)
- `_nextId`: Contador para generar IDs secuenciales, inicia en 1

**Métodos:**

**`_generateId()`**: Genera IDs con formato PRO-XXX. Usa `padLeft(3, '0')` para rellenar con ceros e incrementa el contador.

**`getAll()`**: Retorna la lista `_products` directamente.

**`add(Product product)`**: Genera un ID automático con `_generateId()`, crea una nueva instancia de Product con ese ID (reemplazando el ID original) y lo agrega a `_products`. Necesario crear nueva instancia porque Product es inmutable.

**`update(Product product)`**: Busca el producto por ID usando `indexWhere`. Si existe (index != -1), reemplaza el producto completo en esa posición.

**`delete(String productId)`**: Usa `removeWhere` para eliminar productos que coincidan con el ID.

---

## Repositories

### `product_repository_impl.dart`

```dart
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
```

#### Propósito

Implementa el contrato `ProductRepository` del dominio. Actúa como puente entre la capa de dominio y el datasource, delegando todas las operaciones.

#### Interacciones

**Usa:**
- `data/datasources/product_memory_datasource.dart`
- `domain/entities/product.dart`
- `domain/repositories/product_repository.dart` (implementa)

**Usado por:**
- Casos de uso del dominio (a través de inyección de dependencias)

#### Descripción del Código

**Clase**: Implementa `ProductRepository` con el sufijo `Impl` para indicar que es una implementación concreta.

**Atributo `datasource`**: Dependencia inyectada del tipo `ProductMemoryDatasource`, marcada como `final`.

**Constructor**: Recibe el datasource por inyección de dependencias.

**Métodos**: Todos los métodos (`getProducts`, `addProduct`, `updateProduct`, `deleteProduct`) son delegaciones directas al datasource con `@override`

---

## Resumen

**2 archivos en la capa Data:**
- `ProductMemoryDatasource`: Almacenamiento en memoria con IDs autogenerados (PRO-001, PRO-002...)
- `ProductRepositoryImpl`: Implementa el contrato del dominio delegando al datasource

**Flujo:**
```
Use Case → Repository (interface) → RepositoryImpl → DataSource → Memoria RAM
```
