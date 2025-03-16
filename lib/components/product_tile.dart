import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu/detail_page.dart';
import 'package:il_tris_manager/components/menu/menu_tile.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:pizzeria_model_package/model/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});
  final Product product;
  static const double _elevation = 3;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      middleColor: colorScheme.secondaryContainer,
      openColor: colorScheme.secondaryContainer,
      transitionDuration: animationDuration,
      closedBuilder: (context, action) =>
          MenuTile(product: product, onTap: action),
      closedElevation: _elevation,
      closedColor: colorScheme.surface,
      openBuilder: (context, action) => DetailPage(
        product: product,
        onTap: action,
      ),
    );
  }
}
