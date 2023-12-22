import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/circle_widget.dart';
import 'package:il_tris_manager/components/menu_components/menu_add_product_form.dart';

class MenuAddPage extends StatelessWidget {
  const MenuAddPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Aggiungi prodotto",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: const Stack(
        children: [
          Positioned(
            bottom: -130,
            right: -110,
            child: CircleWidget(
              radius: 120,
              opacity: 100,
            ),
          ),
          Positioned(
            top: 120,
            left: -90,
            child: CircleWidget(
              radius: 120,
            ),
          ),
          Positioned(
            top: -150,
            right: -120,
            child: CircleWidget(
              radius: 178,
            ),
          ),
          MenuAddProductForm()
        ],
      ),
    );
  }
}
