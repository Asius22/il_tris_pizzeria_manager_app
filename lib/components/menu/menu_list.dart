import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/menu/menu_add_button.dart';
import 'package:il_tris_manager/components/utils/dismissable_widget.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:il_tris_manager/components/product_tile.dart';
import 'package:il_tris_manager/components/repository_dialog.dart';
import 'package:pizzeria_model_package/model/product.dart';

class MenuList extends StatelessWidget {
  const MenuList({super.key, required this.productType});

  final ProductType productType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductBlocState>(
      buildWhen: (previous, current) {
        if (current is ProductBlocFetching ||
            previous is ProductBlocFetching ||
            current is ProductBlocInitial ||
            previous is ProductBlocInitial) {
          return true;
        }

        return !listEquals(
          _productsByType(previous.products),
          _productsByType(current.products),
        );
      },
      builder: (context, state) {
        final ProductBloc provider = context.read<ProductBloc>();

        if (state is ProductBlocInitial) {
          return const WaitingPage();
        } else if (state is ProductBlocFetching) {
          return const WaitingPage();
        }
        final products = _productsByType(state.products);

        return Scaffold(
            appBar: AppBar(
              title: Text(productType.name),
            ),
            floatingActionButton: MenuAddButton(
              productType: productType,
            ),
            body: RefreshIndicator(
              color: Theme.of(context).colorScheme.tertiary,
              onRefresh: () {
                provider.add(FetchProductEvent());
                return Future.delayed(const Duration(milliseconds: 1));
              },
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DismissableWidget(
                        dismissibleKey:
                            ValueKey('${item.type.key}-${item.nome}'),
                        child: ProductTile(product: item),
                        askForDismiss: () => _askForDismiss(context, item),
                        onDismiss: () =>
                            provider.add(RemoveProductEvent(product: item)),
                      ));
                },
              ),
            ));
      },
    );
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

  List<Product> _productsByType(List<Product> products) =>
      products.where((p) => p.type == productType).toList(growable: false);
}
