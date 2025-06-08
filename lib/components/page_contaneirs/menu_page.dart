import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/menu/menu_list.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:sizer/sizer.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key, this.productList = const []});

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    final List<ProductType> types = ProductType.values.map((e) => e).toList()
      ..sort(
        (a, b) => a.name.compareTo(b.name),
      );
    return SizedBox(
      width: 100.w,
      child: ListView(
        children: types
            .map<Widget>(
              (categoria) => Padding(
                padding: const EdgeInsets.all(8),
                child: FilledButton.tonal(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuList(
                              productType: categoria,
                            ),
                          ),
                        ),
                    child: Text(categoria.name.toUpperCase())),
              ),
            )
            .toList()
          ..addAll([
            _translatorButton(context),
            ElevatedButton(
                onPressed: () {
                  for (Product p in productList) {
                    BlocProvider.of<ProductBloc>(context)
                        .add(SaveProductEvent(product: p));
                  }
                },
                child: const Text('Scrivi Tutto'))
          ]),
      ),
    );
  }

  Widget _translatorButton(BuildContext context) => ElevatedButton.icon(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.all(16),
          ),
        ),
        onPressed: () {
          BlocProvider.of<ProductBloc>(context).add(TranslateAllProductEvent());
        },
        icon: const Icon(Icons.translate),
        label: const Text(' TRADUCI TUTTO '),
      );
}
