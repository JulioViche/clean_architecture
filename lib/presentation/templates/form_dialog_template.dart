import 'package:flutter/material.dart';

/// Template: Layout para diálogos de formulario
class FormDialogTemplate extends StatelessWidget {
  final String title;
  final Widget form;

  const FormDialogTemplate({
    super.key,
    required this.title,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: form,
      ),
    );
  }
}
