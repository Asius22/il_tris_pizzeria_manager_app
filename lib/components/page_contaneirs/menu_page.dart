import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu_components/menu_add_button.dart';
import 'package:il_tris_manager/components/menu_components/menu_list.dart';
import 'package:pizzeria_model_package/product.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.productList = const []});
  final List<Product> productList;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final TextEditingController _search;
  String _filter = "";
  @override
  void initState() {
    _search = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
                      onEditingComplete: () {
                        setState(() {
                          _filter = _search.text;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MenuList(
                productList: widget.productList,
                filter: _filter.toLowerCase().trim(),
              ),
            ),
          ],
        ),
        const Positioned(right: 20, bottom: 20, child: MenuAddButton())
      ],
    );
  }
}
