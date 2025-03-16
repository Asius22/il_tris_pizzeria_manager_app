import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu/menu_add_page.dart';
import 'package:il_tris_manager/components/util_info.dart';

class MenuAddButton extends StatelessWidget {
  const MenuAddButton({super.key, required this.productType});

  final String productType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: animationDuration,
      closedColor: Theme.of(context).colorScheme.primaryContainer,
      closedElevation: 10,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      closedBuilder: (context, action) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: IconButton(
          onPressed: action,
          icon: Icon(
            Icons.add_outlined,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      openBuilder: (context, action) => MenuAddPage(
        categoria: productType,
      ),
    );
  }
}
