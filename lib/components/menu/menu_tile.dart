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
    final price = product.prezzi.isEmpty
        ? null
        : '\u20AC ${product.prezzi.first.toStringAsFixed(2)}';

    return Material(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    if (price != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: product.active,
                onChanged: (value) {
                  context.read<ProductBloc>().add(
                        UpdateProductEvent(
                          newProduct: product.copyWith(active: value),
                          key: product.nome,
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
