import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:il_tris_manager/components/circle_widget.dart';
import 'package:il_tris_manager/components/menu_components/detail_product_form.dart';
import 'package:il_tris_manager/components/repository_dialog.dart';
import 'package:pizzeria_model_package/product.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.product, this.onTap});
  final Product product;
  final Function()? onTap;

  final _formKey = GlobalKey<DetailProductFormState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorScheme.secondaryContainer,
        title: Text(
          product.nome,
          style: TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => _saveProductUpdate(context),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              const Positioned(
                bottom: -130,
                right: -110,
                child: CircleWidget(
                  radius: 120,
                  opacity: 100,
                ),
              ),
              const Positioned(
                top: 120,
                left: -90,
                child: CircleWidget(
                  radius: 120,
                ),
              ),
              const Positioned(
                top: -150,
                right: -120,
                child: CircleWidget(
                  radius: 178,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: DetailProductForm(key: _formKey, product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///controlla se ci sono state modifiche, in caso affermativo esegue la modifica
  void _saveProductUpdate(BuildContext context) async {
    Product p = _formKey.currentState!.productUpdated;
    if (p != product) {
      await showDialog<bool>(
          context: context,
          builder: (context) => RepositoryDialog(
                action: RepositoryDialogAction.aggiorna,
                product: p,
              )).then((value) => Navigator.of(context).pop());
    } else {
      Fluttertoast.showToast(msg: "Prodotti uguali");
    }
  }
}
