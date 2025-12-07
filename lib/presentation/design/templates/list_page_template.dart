import 'package:flutter/material.dart';

/// Template: Layout para pantallas con lista
class ListPageTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onAddPressed;

  const ListPageTemplate({
    super.key,
    required this.title,
    required this.body,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        actions: [
          if (onAddPressed != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAddPressed,
              tooltip: 'Agregar',
            ),
        ],
      ),
      body: body,
    );
  }
}
