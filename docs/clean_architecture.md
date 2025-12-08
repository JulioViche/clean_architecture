# Clean Arquitecture

## Capa `/domain`

(ver [domain.md](domain.md) para más detalles)

### ¿Qué es un modelo o entidad?
  
Una entidad o modelo representa un objeto de negocio del mundo real con sus atributos principales. En este proyecto, la entidad `Product` define la estructura básica de un producto:

```dart
class Product {
	final String id;
	final String name;
	final double price;
}
```

Las entidades deben ser clases limpias, sin lógica de negocio ni métodos complejos, solo datos inmutables que representan conceptos del dominio.

### ¿Qué son los casos de uso?
  
Los casos de uso encapsulan la lógica de negocio específica de la aplicación. Cada caso de uso representa una acción que el usuario puede realizar. En este proyecto tenemos:

- `GetProducts`: Obtiene la lista de productos
- `AddProduct`: Agrega un nuevo producto
- `UpdateProduct`: Actualiza un producto existente
- `DeleteProduct`: Elimina un producto

Ejemplo de implementación:

```dart
class GetProducts {
	final ProductRepository repository;

	GetProducts(this.repository);

	List<Product> call() => repository.getProducts();
}
```

Cada caso de uso depende del `ProductRepository` (interfaz), no de implementaciones concretas, siguiendo el principio de inversión de dependencias.

## Capa `/data`

(ver [data.md](data.md) para más detalles)

### ¿Para qué sirve el repositorio?
  
El repositorio es un intermediario entre la capa de dominio y las fuentes de datos. Su propósito es:

1. **Abstraer la fuente de datos**: La capa de dominio no conoce de dónde vienen los datos (memoria, API, base de datos)
2. **Implementar el contrato del dominio**: `ProductRepositoryImpl` implementa la interfaz `ProductRepository` definida en el dominio
3. **Coordinar las operaciones**: Delega las operaciones al datasource correspondiente

```dart
class ProductRepositoryImpl implements ProductRepository {
	final ProductMemoryDatasource datasource;

	@override
	List<Product> getProducts() => datasource.getAll();

	@override
	void addProduct(Product product) => datasource.add(product);
}
```

Esto permite cambiar la implementación del datasource sin afectar la lógica de negocio.

### ¿Cómo se manejan las fuentes de datos?
  
Las fuentes de datos (datasources) son las responsables de acceder a los datos concretos. En este proyecto se usa `ProductMemoryDatasource` que almacena productos en memoria local (una lista en RAM):

```dart
class ProductMemoryDatasource {
final List<Product> _products = [];
int _nextId = 1;

// Generar ID automático con formato PRO-XXX
String _generateId() {
	final id = 'PRO-${_nextId.toString().padLeft(3, '0')}';
	_nextId++;
	return id;
}

List<Product> getAll() => _products;
void add(Product product) { /* ... */ }
void update(Product product) { /* ... */ }
void delete(String productId) { /* ... */ }
}
```

Características del datasource en memoria:
- Genera IDs automáticos con formato `PRO-001`, `PRO-002`, etc.
- Los datos se pierden al cerrar la aplicación
- Operaciones CRUD básicas (Create, Read, Update, Delete)
- Puede ser reemplazado por un datasource de API o base de datos sin modificar el repositorio ni el dominio

## Capa `/presentation`

### Pantallas (UI)

La aplicación cuenta con una pantalla principal que gestiona la lista de productos:

- **`ProductListScreen`**: Pantalla principal que muestra todos los productos y permite crear, editar y eliminar productos mediante diálogos modales.

```dart
class ProductListScreen extends StatelessWidget {
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
}
```

La pantalla utiliza el patrón `Consumer` de Provider para escuchar cambios en el estado y reaccionar automáticamente cuando se agregan, editan o eliminan productos.

### Provider (Manejador del Estado)

El `ProductProvider` es el gestor de estado que conecta la UI con los casos de uso del dominio:

```dart
class ProductProvider extends ChangeNotifier {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final UpdateProduct updateProductUseCase;
  final DeleteProduct deleteProductUseCase;

  List<Product> get products => getProductsUseCase();

  void add(product) {
    addProductUseCase(product);
    notifyListeners(); // Notifica a los widgets para que se actualicen
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
```

**Responsabilidades del Provider:**
1. **Inyección de dependencias**: Recibe los casos de uso a través del constructor
2. **Exponer datos**: Proporciona acceso a la lista de productos mediante el getter `products`
3. **Ejecutar acciones**: Delega las operaciones CRUD a los casos de uso correspondientes
4. **Notificar cambios**: Llama a `notifyListeners()` después de cada operación para que los widgets se reconstruyan con los datos actualizados

### Widgets

El proyecto utiliza **Atomic Design** para organizar los componentes visuales (ver [presentation.md](presentation.md) para más detalles):

#### **Átomos** (Componentes básicos)
- `CustomButton`: Botón personalizado reutilizable con iconos opcionales
- `CustomIconButton`: Botón de icono para acciones rápidas
- `LabelText`: Texto de etiqueta para información secundaria
- `PriceText`: Formato especializado para mostrar precios
- `ProductIcon`: Icono representativo de productos

#### **Moléculas** (Combinación de átomos)
- `ProductInfo`: Combina icono, nombre, ID y precio del producto
- `ActionButtons`: Grupo de botones de editar y eliminar
- `FormTextField`: Campo de texto personalizado para formularios
- `InfoRow`: Fila de información con label y valor

#### **Organismos** (Secciones complejas)
- `ProductCard`: Tarjeta completa de producto con información y acciones
- `ProductList`: Lista scrolleable de productos con manejo de estado vacío
- `ProductForm`: Formulario para crear/editar productos con validación
- `DeleteDialog`: Diálogo de confirmación de eliminación
- `EmptyState`: Estado vacío cuando no hay productos

#### **Templates** (Layouts estructurales)
- `ListPageTemplate`: Layout base para pantallas con lista y botón de agregar
- `FormDialogTemplate`: Template para diálogos con formularios

**Ejemplo de composición:**

```dart
ProductCard                    // Organismo
├── ProductInfo                // Molécula
│   ├── ProductIcon           // Átomo
│   ├── LabelText             // Átomo
│   └── PriceText             // Átomo
└── ActionButtons             // Molécula
    ├── CustomIconButton      // Átomo (Editar)
    └── CustomIconButton      // Átomo (Eliminar)
```

Esta arquitectura de widgets permite máxima reutilización y mantenimiento del código UI.

### Mapa Conceptual

Se debe incluir un **mapa conceptual o mental** que explique la interacción entre las capas.