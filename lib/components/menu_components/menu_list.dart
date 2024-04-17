import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:il_tris_manager/components/product_tile.dart';
import 'package:il_tris_manager/components/repository_dialog.dart';
import 'package:pizzeria_model_package/product.dart';

class MenuList extends StatelessWidget {
  const MenuList({super.key, this.filter = "", required this.productList});
  final String filter;
  final List<Product> productList;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.tertiary,
      onRefresh: () {
        BlocProvider.of<ProductBloc>(context).add(FetchProductEvent());
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: ListView.builder(
        itemCount: productList.length + 1,
        itemBuilder: (context, index) {
          final item = productList[index == productList.length ? 0 : index];
          if (filter == "" ||
              item.type.toLowerCase().contains(filter) ||
              item.nome.toLowerCase().contains(filter)) {
            return index == productList.length
                ? _translatorButton(context)
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) =>
                          _askForDismiss(context, item),
                      onDismissed: (direction) => _handleDismiss(item),
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          color: Theme.of(context).colorScheme.errorContainer,
                        ),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Elimina",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                          ),
                        ),
                      ),
                      key: Key("${item.nome}${item.type}"),
                      child: ProductTile(product: item),
                    ),
                  );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _translatorButton(BuildContext context) => ElevatedButton.icon(
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.all(16))),
        onPressed: () {
          BlocProvider.of<ProductBloc>(context).add(TranslateAllProductEvent());
        },
        icon: const Icon(Icons.translate),
        label: const Text(" TRADUCI TUTTO "),
      );

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
    productList.removeAt(productList.indexOf(p));
  }
}
