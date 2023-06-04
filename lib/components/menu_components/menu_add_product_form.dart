import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/product_type_dropdown.dart';
import 'package:il_tris_manager/components/repository_dialog.dart';
import 'package:il_tris_manager/model/product.dart';

class MenuAddProductForm extends StatefulWidget {
  const MenuAddProductForm({super.key});

  @override
  State<MenuAddProductForm> createState() => _MenuAddProductFormState();
}

class _MenuAddProductFormState extends State<MenuAddProductForm> {
  late final TextEditingController _typeController,
      _nameController,
      _descriptionController;
  late final List<TextEditingController> _priceControllerList;
  static const _textFieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(),
  );
  static const _padding =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0);
  final List<Widget> _priceFields = [];
  @override
  void initState() {
    _typeController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceControllerList = [
      TextEditingController(
        text: "0.0",
      )
    ];
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (var c in _priceControllerList) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: _padding,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: _padding,
                  child: TextField(
                    decoration: _textFieldInputDecoration.copyWith(
                        label: const Text("nome")),
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: _padding,
                  child: TextField(
                    decoration: _textFieldInputDecoration.copyWith(
                        label: const Text("descrizione")),
                    controller: _descriptionController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [..._getPriceFields()],
                ),
                const Expanded(
                  flex: 5,
                  child: SizedBox(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton.icon(
                      onPressed: _aggiungiPrezzo,
                      icon: const Icon(Icons.add),
                      label: const Text("aggiungi prezzo"),
                    ),
                    FilledButton.icon(
                      onPressed: _rimuoviPrezzo,
                      icon: const Icon(Icons.remove),
                      label: const Text("rimuovi prezzo"),
                    ),
                  ],
                ),
                Padding(
                  padding: _padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Tipo del prodotto: "),
                      ProductTypeDropdown(
                        controller: _typeController,
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () => _saveProduct(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _aggiungiPrezzo() {
    if (_priceFields.length < 3) {
      setState(() {
        final controller = TextEditingController(text: "0.0");
        _priceControllerList.add(controller);
        final c = Container(
          margin: const EdgeInsets.all(8.0),
          width: 80,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text("prezzo")),
            controller: controller,
          ),
        );
        _priceFields.add(c);
      });
    }
  }

  void _rimuoviPrezzo() {
    if (_priceFields.length > 1) {
      _priceControllerList.last.dispose();
      _priceControllerList.removeLast();
      setState(() {
        _priceFields.removeLast();
      });
    }
  }

  void _saveProduct(BuildContext context) async {
    final List<double> prezzi = [];
    for (var c in _priceControllerList) {
      prezzi.add(double.tryParse(c.text) ?? 0.0);
    }
    await showDialog(
      context: context,
      builder: (context) => RepositoryDialog(
        action: RepositoryDialogAction.salva,
        product: Product(
          nome: _nameController.text,
          descrizione: _descriptionController.text,
          type: _typeController.text,
          prezzi: prezzi,
        ),
      ),
    );
  }

  List<Widget> _getPriceFields() {
    if (_priceFields.isEmpty) {
      _priceFields.add(Container(
        margin: const EdgeInsets.all(16.0),
        width: 80,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("prezzo")),
          controller: _priceControllerList[0],
        ),
      ));
    }
    return _priceFields;
  }
}
