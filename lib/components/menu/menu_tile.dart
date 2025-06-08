import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({super.key, required this.product, required this.onTap});

  final Product product;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final containerColor = colorScheme.secondaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: containerColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.nome,
              style: textTheme.bodyLarge,
            ),
            Switch(
              value: product.active,
              onChanged: (value) {
                BlocProvider.of<ProductBloc>(context).add(UpdateProductEvent(
                    newProduct: product.copyWith(active: value),
                    key: product.nome));
              },
            )
          ],
        ),
      ),
    );
  }
}
