import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu/menu_add_product_form.dart';

class MenuAddPage extends StatelessWidget {
  const MenuAddPage({super.key, required this.categoria});

  final String categoria;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Aggiungi $categoria',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        body: MenuAddProductForm(
          type: categoria,
        ));
  }
}
