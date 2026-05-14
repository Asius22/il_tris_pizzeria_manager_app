import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/blocs/translator_bloc.dart' as translator;
import 'package:il_tris_manager/components/menu/menu_list.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:sizer/sizer.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key, this.productList = const []});

  static final List<ProductType> _types = List.unmodifiable(
    ProductType.values.toList()
      ..sort(
        (a, b) => a.name.compareTo(b.name),
      ),
  );

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 100.w,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Menu', style: textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Seleziona una categoria da modificare',
            style: textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 720 ? 3 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _types.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 72,
                ),
                itemBuilder: (context, index) =>
                    _CategoryButton(categoria: _types[index]),
              );
            },
          ),
          const SizedBox(height: 16),
          _translatorButton(context),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              for (Product p in productList) {
                BlocProvider.of<ProductBloc>(context)
                    .add(SaveProductEvent(product: p));
              }
            },
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Scrivi tutto'),
          ),
        ],
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
          BlocProvider.of<translator.TranslatorBloc>(context).add(
            translator.TranslateAllProductEvent(
              BlocProvider.of<ProductBloc>(context).lingue.toList(),
              productList,
            ),
          );
        },
        icon: const Icon(Icons.translate),
        label: const Text(' TRADUCI TUTTO '),
      );
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({required this.categoria});

  final ProductType categoria;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.tonalIcon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuList(productType: categoria),
        ),
      ),
      icon: Icon(
        Icons.restaurant_menu_outlined,
        color: colorScheme.onSecondaryContainer,
      ),
      label: Text(
        categoria.name.toUpperCase(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
