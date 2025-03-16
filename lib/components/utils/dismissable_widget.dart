import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/repository_dialog.dart';
import 'package:pizzeria_model_package/model/product.dart';

class DismissableWidget extends StatelessWidget {
  const DismissableWidget({super.key, required this.child, this.askForDismiss, this.onDismiss});
  final Widget child;
  final Function? askForDismiss;
  final Function? onDismiss;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => askForDismiss?.call(),
      onDismissed: (direction) => onDismiss?.call(),
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
      key: Key("${child.hashCode}"),
      child: child,
    );
  }


}
