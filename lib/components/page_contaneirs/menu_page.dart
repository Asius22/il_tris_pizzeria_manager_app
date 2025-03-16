import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/menu/menu_list.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:sizer/sizer.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key, this.productList = const []});

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: ListView(
        children: typeList
            .map<Widget>(
              (categoria) => Padding(
                padding: EdgeInsets.all(8),
                child: FilledButton.tonal(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuList(
                              productType: categoria,
                              productList: productList
                                  .where(
                                    (element) => element.type == categoria,
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                    child: Text(categoria)),
              ),
            )
            .toList()
          ..add(
            _translatorButton(context),
          ),
      ),
    );
  }

  // TODO: testare
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
        label: const Text(" TRADUCI TUTTO "),
      );
}
