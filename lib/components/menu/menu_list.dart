import 'package:flutter/material.dart';
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
      builder: (context, state) {
        final ProductBloc provider = BlocProvider.of<ProductBloc>(context);

        if (state is ProductBlocInitial) {
          provider.add(FetchProductEvent());
          return const WaitingPage();
        } else if (state is ProductBlocFetching) {
          return const WaitingPage();
        }
        final products =
            state.products.where((p) => p.type == productType).toList();

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
}
