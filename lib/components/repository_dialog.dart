import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/bloc/product_bloc.dart';
import 'package:il_tris_manager/model/product.dart';

class RepositoryDialog extends StatelessWidget {
  const RepositoryDialog(
      {super.key, required this.action, required this.product});
  final Product product;

  ///action può avere valore salva, elimina, aggiorna
  final RepositoryDialogAction action;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_testi[action] ?? "Qualcosa è andato storto, premi no"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () => _onYesPressed(context),
          child: const Text("Si"),
        ),
      ],
    );
  }

  void _onYesPressed(BuildContext context) {
    switch (action) {
      case RepositoryDialogAction.aggiorna:
        BlocProvider.of<ProductBloc>(context)
            .add(UpdateProductEvent(newProduct: product, key: product.nome));
        break;
      case RepositoryDialogAction.salva:
        BlocProvider.of<ProductBloc>(context)
            .add(SaveProductEvent(product: product));
        break;
      case RepositoryDialogAction.elimina:
        BlocProvider.of<ProductBloc>(context)
            .add(RemoveProductEvent(product: product));
        break;
    }

    Navigator.of(context).pop(true);
  }

  final Map<RepositoryDialogAction, String> _testi = const {
    RepositoryDialogAction.salva: "Confermi?",
    RepositoryDialogAction.aggiorna: "Confermi?",
    RepositoryDialogAction.elimina: "Sei sicuro di voler eliminare l'elemento?",
  };
}

enum RepositoryDialogAction { salva, aggiorna, elimina }
