import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu/menu_add_product_form.dart';
import 'package:pizzeria_model_package/model/product.dart';

class MenuAddPage extends StatelessWidget {
  const MenuAddPage({super.key, required this.categoria});

  final ProductType categoria;

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
