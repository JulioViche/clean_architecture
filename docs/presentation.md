# Capa de Presentación - Atomic Design

La capa de presentación de este proyecto está organizada siguiendo el patrón **Atomic Design**, que divide los componentes visuales en niveles jerárquicos de complejidad creciente.

## ¿Qué es Atomic Design?

Atomic Design es una metodología para crear sistemas de diseño mediante la composición de componentes desde los más simples hasta los más complejos:

```
Átomos → Moléculas → Organismos → Templates → Páginas
```

## Estructura del Proyecto

### 1. Átomos (`/design/atoms/`)

Los átomos son los componentes UI más básicos e indivisibles. No dependen de otros componentes personalizados.

#### `CustomButton`
Botón personalizado reutilizable con soporte para iconos.

```dart
CustomButton(
  text: 'Guardar',
  icon: Icons.save,
  onPressed: () => _save(),
  backgroundColor: Colors.blue,
)
```

**Propiedades:**
- `text`: Texto del botón
- `onPressed`: Callback al presionar
- `backgroundColor`: Color de fondo opcional
- `textColor`: Color del texto opcional
- `icon`: Icono opcional

#### `CustomIconButton`
Botón circular con icono para acciones rápidas.

**Uso:** Botones de editar, eliminar, etc.

#### `LabelText`
Texto para etiquetas e información secundaria.

**Uso:** Labels de campos, información adicional

#### `PriceText`
Formato especializado para mostrar precios con el símbolo de moneda.

```dart
PriceText(price: 299.99) // Muestra: $299.99
```

#### `ProductIcon`
Icono representativo para productos (Shopping bag).

---

### 2. Moléculas (`/design/molecules/`)

Las moléculas combinan átomos para crear componentes funcionales más complejos.

#### `ProductInfo`
Muestra la información completa de un producto: icono, nombre, ID y precio.

```dart
ProductInfo(
  id: 'PRO-001',
  name: 'Laptop',
  price: 999.99,
)
```

**Composición:**
- `ProductIcon` (átomo)
- `LabelText` (átomo) - para el ID
- `PriceText` (átomo)
- `Text` estándar - para el nombre

#### `ActionButtons`
Grupo de botones de acción (Editar y Eliminar).

```dart
ActionButtons(
  onEdit: () => _edit(),
  onDelete: () => _delete(),
)
```

**Composición:**
- 2 x `CustomIconButton` (átomo)

#### `FormTextField`
Campo de texto personalizado para formularios con validación.

**Propiedades:**
- `label`: Etiqueta del campo
- `controller`: TextEditingController
- `keyboardType`: Tipo de teclado
- `validator`: Función de validación

#### `InfoRow`
Fila de información con label y valor alineados.

**Uso:** Mostrar pares clave-valor de forma consistente

---

### 3. Organismos (`/design/organisms/`)

Los organismos son secciones completas e independientes de la UI que combinan moléculas y átomos.

#### `ProductCard`
Tarjeta completa de un producto con toda su información y acciones.

```dart
ProductCard(
  product: product,
  onEdit: () => _showEditDialog(product),
  onDelete: () => _showDeleteDialog(product),
)
```

**Composición:**
- `ProductInfo` (molécula)
- `ActionButtons` (molécula)
- `Card` de Material Design

#### `ProductList`
Lista completa de productos con scroll y estado vacío.

```dart
ProductList(
  products: productList,
  onEdit: (product) => _edit(product),
  onDelete: (product) => _delete(product),
)
```

**Funcionalidad:**
- Muestra un `ListView` de `ProductCard`
- Si no hay productos, muestra `EmptyState`
- Maneja el scroll automáticamente

**Composición:**
- `ListView` con múltiples `ProductCard` (organismo)
- `EmptyState` (organismo) cuando la lista está vacía

#### `ProductForm`
Formulario completo para crear o editar productos.

```dart
ProductForm(product: existingProduct) // Editar
ProductForm(product: null)           // Crear nuevo
```

**Funcionalidad:**
- Validación de campos requeridos
- Diferencia entre modo crear/editar
- Se conecta con `ProductProvider` para ejecutar acciones

**Composición:**
- 2 x `FormTextField` (molécula) - nombre y precio
- `CustomButton` (átomo) - botón de guardar

#### `DeleteDialog`
Diálogo de confirmación para eliminar productos.

```dart
DeleteDialog(product: productToDelete)
```

**Funcionalidad:**
- Muestra información del producto a eliminar
- Requiere confirmación explícita
- Se conecta con `ProductProvider.delete()`

#### `EmptyState`
Componente que se muestra cuando no hay productos en la lista.

**Funcionalidad:**
- Mensaje amigable al usuario
- Icono ilustrativo
- Sugerencia de acción

---

### 4. Templates (`/design/templates/`)

Los templates definen la estructura y layout de las páginas sin contenido específico.

#### `ListPageTemplate`
Layout base para pantallas con lista.

```dart
ListPageTemplate(
  title: 'Productos',
  onAddPressed: () => _showAddDialog(),
  body: ProductList(...),
)
```

**Estructura:**
- `AppBar` con título y botón de agregar
- Área de contenido flexible (`body`)

#### `FormDialogTemplate`
Template para diálogos que contienen formularios.

```dart
FormDialogTemplate(
  title: 'Agregar Producto',
  form: ProductForm(product: null),
)
```

**Estructura:**
- `AlertDialog` estándar
- Título personalizado
- Contenido del formulario

---

### 5. Páginas (`/screens/`)

Las páginas son pantallas completas que combinan templates, organismos y la lógica de estado.

#### `ProductListScreen`
Pantalla principal de la aplicación.

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

**Responsabilidades:**
- Conectar con el Provider mediante `Consumer`
- Coordinar la navegación y diálogos
- Pasar datos y callbacks a los organismos

---

## Flujo de Datos en la Presentación

```
Usuario interactúa con Widget
         ↓
Widget llama callback de la Página
         ↓
Página ejecuta método del Provider
         ↓
Provider llama al Caso de Uso
         ↓
Caso de Uso ejecuta lógica de negocio
         ↓
Provider notifica cambios (notifyListeners)
         ↓
Consumer reconstruye los Widgets
         ↓
UI se actualiza automáticamente
```

## Ventajas de Atomic Design

1. **Reutilización**: Los átomos y moléculas se usan en múltiples contextos
2. **Mantenimiento**: Cambios en un átomo se reflejan en todos los lugares donde se usa
3. **Consistencia**: El diseño se mantiene coherente en toda la aplicación
4. **Escalabilidad**: Fácil agregar nuevas pantallas combinando componentes existentes
5. **Testing**: Los componentes pequeños son más fáciles de probar
6. **Documentación implícita**: La jerarquía explica la estructura

## Ejemplo de Composición Completa

```
ProductListScreen                         // Pantalla
└── Consumer<ProductProvider>            // Estado
    └── ListPageTemplate                 // Template
        └── ProductList                   // Organismo
            ├── ProductCard               // Organismo
            │   ├── ProductInfo          // Molécula
            │   │   ├── ProductIcon      // Átomo
            │   │   ├── Text             // Átomo Flutter
            │   │   ├── LabelText        // Átomo
            │   │   └── PriceText        // Átomo
            │   └── ActionButtons        // Molécula
            │       ├── CustomIconButton // Átomo
            │       └── CustomIconButton // Átomo
            └── EmptyState               // Organismo
```

## Conexión con el Estado

Los organismos y páginas se conectan con `ProductProvider` usando el patrón Provider de Flutter:

### Consumer Pattern
```dart
Consumer<ProductProvider>(
  builder: (context, provider, child) {
    // Acceder a datos: provider.products
    // Ejecutar acciones: provider.add(), provider.update(), provider.delete()
    return Widget(...);
  },
)
```

### Provider.of Pattern
```dart
final provider = Provider.of<ProductProvider>(context);
provider.add(newProduct);
```

Esta separación clara entre UI (widgets) y lógica (provider) mantiene el código organizado y testeable.
