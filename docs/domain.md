# Capa Domain - Documentación Técnica

La capa **Domain** es el núcleo de la aplicación. Contiene la lógica de negocio pura, independiente de frameworks, UI o fuentes de datos.

## Estructura

```
domain/
├── entities/
│   └── product.dart
├── repositories/
│   └── product_repository.dart
└── use_cases/
    ├── get_products.dart
    ├── add_product.dart
    ├── update_product.dart
    └── delete_product.dart
```

---

## Entities

### `product.dart`

```dart
class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

/*
  NOTES:
  Las clases deben ser lo más limpias posibles, sin métodos.
*/
```

#### Propósito

Entidad que representa un producto del dominio. Modelo de datos inmutable sin lógica de negocio.

#### Interacciones

**Usa:**
- Ninguna dependencia

**Usado por:**
- Todos los archivos del dominio, data y presentation que manejan productos

#### Descripción del Código

**Atributos** (todos `final` para inmutabilidad):
- `id`: Identificador único (formato PRO-XXX generado por datasource)
- `name`: Nombre del producto
- `price`: Precio en formato decimal

**Constructor**: Parámetros nombrados con `required` para garantizar que todos los campos se inicialicen.

---

## Repositories

### `product_repository.dart`

```dart
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
```

#### Propósito

Interfaz (contrato) que define operaciones de acceso a datos para productos. Abstrae la implementación real (memoria, API, BD).

#### Interacciones

**Usa:**
- `domain/entities/product.dart`

**Usado por:**
- Los 4 casos de uso del dominio

**Implementado por:**
- `data/repositories/product_repository_impl.dart`

#### Descripción del Código

**Clase abstracta** que define 4 métodos:

- `getProducts()`: Retorna `List<Product>`
- `addProduct(Product product)`: Agrega producto (void)
- `updateProduct(Product product)`: Actualiza producto por ID (void)
- `deleteProduct(String productId)`: Elimina producto por ID (void)

---

## Use Cases

Cada caso de uso encapsula una acción específica del dominio.

### `get_products.dart`

```dart
import '../repositories/product_repository.dart';
import '../entities/product.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  List<Product> call() => repository.getProducts();
}
```

#### Propósito

Obtiene la lista completa de productos del repositorio.

#### Interacciones

**Usa:**
- `domain/repositories/product_repository.dart`
- `domain/entities/product.dart`

**Usado por:**
- `presentation/providers/product_provider.dart`

#### Descripción del Código

**Constructor**: Recibe `ProductRepository` por inyección de dependencias.

**Método `call()`**: Delega a `repository.getProducts()`. Retorna `List<Product>`. El método `call()` permite invocar la instancia como función: `getProductsUseCase()`.

---

### `add_product.dart`

```dart
import '../repositories/product_repository.dart';
import '../entities/product.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  void call(Product product) => repository.addProduct(product);
}
```

#### Propósito

Agrega un nuevo producto al sistema.

#### Interacciones

**Usa:**
- `domain/repositories/product_repository.dart`
- `domain/entities/product.dart`

**Usado por:**
- `presentation/providers/product_provider.dart`

#### Descripción del Código

**Constructor**: Recibe `ProductRepository` por inyección de dependencias.

**Método `call(Product product)`**: Delega a `repository.addProduct(product)`. El producto puede venir con ID vacío ya que el datasource genera el ID definitivo.

---

### `update_product.dart`

```dart
import '../repositories/product_repository.dart';
import '../entities/product.dart';

class UpdateProduct {
  final ProductRepository repository;
  
  UpdateProduct(this.repository);

  void call(Product product) => repository.updateProduct(product);
}
```

#### Propósito

Actualiza un producto existente.

#### Interacciones

**Usa:**
- `domain/repositories/product_repository.dart`
- `domain/entities/product.dart`

**Usado por:**
- `presentation/providers/product_provider.dart`

#### Descripción del Código

**Constructor**: Recibe `ProductRepository` por inyección de dependencias.

**Método `call(Product product)`**: Delega a `repository.updateProduct(product)`. Usa `product.id` para localizar el producto y reemplaza todos sus campos.

---

### `delete_product.dart`

```dart
import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  void call(String productId) => repository.deleteProduct(productId);
}
```

#### Propósito

Elimina un producto del sistema.

#### Interacciones

**Usa:**
- `domain/repositories/product_repository.dart`

**Usado por:**
- `presentation/providers/product_provider.dart`

#### Descripción del Código

**Constructor**: Recibe `ProductRepository` por inyección de dependencias.

**Método `call(String productId)`**: Delega a `repository.deleteProduct(productId)`. Solo requiere el ID, no el objeto completo.

---

---

## Resumen

**6 archivos en la capa Domain:**
- `Product`: Entidad inmutable (id, name, price)
- `ProductRepository`: Interfaz con 4 métodos CRUD
- `GetProducts`, `AddProduct`, `UpdateProduct`, `DeleteProduct`: Casos de uso que delegan al repositorio

**Flujo:**
```
Provider → Use Case → Repository (interface) → RepositoryImpl (data) → DataSource
```
