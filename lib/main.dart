import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Data Layer
import 'data/datasources/product_memory_datasource.dart';
import 'data/repositories/product_repository_impl.dart';

// Domain Layer
import 'domain/entities/product.dart';
import 'domain/use_cases/add_product.dart';
import 'domain/use_cases/delete_product.dart';
import 'domain/use_cases/get_products.dart';
import 'domain/use_cases/update_product.dart';

// Presentation Layer
import 'presentation/providers/product_provider.dart';
import 'presentation/screens/product_list_screen.dart';

void main() {
  // 1. CAPA DE DATOS: Crear datasource con datos iniciales
  final datasource = ProductMemoryDatasource();
  // El ID será generado automáticamente (PRO-001, PRO-002, etc.)
  datasource.add(Product(id: '', name: 'iPhone 15 Pro', price: 999.99));
  datasource.add(Product(id: '', name: 'Samsung Galaxy S24', price: 899.99));
  datasource.add(Product(id: '', name: 'MacBook Air M3', price: 1299.99));

  // 2. CAPA DE DATOS: Crear repositorio
  final repository = ProductRepositoryImpl(datasource);

  // 3. CAPA DE DOMINIO: Crear casos de uso
  final getProducts = GetProducts(repository);
  final addProduct = AddProduct(repository);
  final updateProduct = UpdateProduct(repository);
  final deleteProduct = DeleteProduct(repository);

  // 4. CAPA DE PRESENTACIÓN: Crear provider
  final productProvider = ProductProvider(
    getProductsUseCase: getProducts,
    addProductUseCase: addProduct,
    updateProductUseCase: updateProduct,
    deleteProductUseCase: deleteProduct,
  );

  // 5. Ejecutar aplicación
  runApp(MyApp(productProvider: productProvider));
}

class MyApp extends StatelessWidget {
  final ProductProvider productProvider;

  const MyApp({super.key, required this.productProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: productProvider,
      child: MaterialApp(
        title: 'Clean Architecture - CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}