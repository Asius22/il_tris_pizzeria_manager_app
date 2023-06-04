import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu_components/detail_page.dart';
import 'package:il_tris_manager/components/menu_components/menu_tile.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:il_tris_manager/model/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});
  final Product product;
  static const double _elevation = 10;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      middleColor: colorScheme.secondaryContainer,
      openColor: colorScheme.secondaryContainer,
      transitionDuration: animationDuration,
      closedBuilder: (context, action) =>
          MenuTile(product: product, onTap: action),
      closedElevation: _elevation,
      closedColor: colorScheme.background,
      openBuilder: (context, action) => DetailPage(
        product: product,
        onTap: action,
      ),
    );
  }
}
