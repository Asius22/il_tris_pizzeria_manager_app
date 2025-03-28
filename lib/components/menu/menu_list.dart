import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/menu/menu_add_button.dart';
import 'package:il_tris_manager/components/utils/dismissable_widget.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:il_tris_manager/components/product_tile.dart';
import 'package:il_tris_manager/components/repository_dialog.dart';
import 'package:pizzeria_model_package/model/product.dart';

class MenuList extends StatefulWidget {
  const MenuList(
      {super.key, required this.productList, required this.productType});

  final String productType;
  final List<Product> productList;

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    final ProductBloc provider = BlocProvider.of<ProductBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.productType),
        ),
        floatingActionButton: MenuAddButton(
          productType: widget.productType,
        ),
        body: BlocBuilder<ProductBloc, ProductBlocState>(
          builder: (context, state) {
            if (state is ProductBlocInitial) {
              provider.add(FetchProductEvent());
            }
            return RefreshIndicator(
              color: Theme.of(context).colorScheme.tertiary,
              onRefresh: () {
                provider.add(FetchProductEvent());
                return Future.delayed(const Duration(milliseconds: 1));
              },
              child: ListView.builder(
                itemCount: widget.productList.length,
                itemBuilder: (context, index) {
                  final item = widget.productList[index];

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DismissableWidget(
                        child: ProductTile(product: item),
                        askForDismiss: () => _askForDismiss(context, item),
                        onDismiss: () => _handleDismiss(item),
                      ));
                },
              ),
            );
          },
        ));
  }

  Future<bool> _askForDismiss(BuildContext context, Product p) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => RepositoryDialog(
          action: RepositoryDialogAction.elimina,
          product: p,
        ),
      ) ??
      false;

  void _handleDismiss(Product p) {
    setState(() {
      BlocProvider.of<ProductBloc>(context).add(RemoveProductEvent(product: p));
      // widget.productList.removeAt(widget.productList.indexOf(p));
    });
  }
}
