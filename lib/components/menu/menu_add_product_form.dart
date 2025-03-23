import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu/allergeni_select_list.dart';
import 'package:il_tris_manager/components/text_fields/outlined_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:translator/translator.dart';

class MenuAddProductForm extends StatefulWidget {
  const MenuAddProductForm({super.key, required this.type});

  final String type;

  @override
  State<MenuAddProductForm> createState() => _MenuAddProductFormState();
}

class _MenuAddProductFormState extends State<MenuAddProductForm> {
  late final TextEditingController _nameController, _descriptionController;
  late final List<TextEditingController> _priceControllerList;

  final List<Widget> _priceFields = [];
  final AllergeniSelectList allergeniController = AllergeniSelectList();

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceControllerList = [
      TextEditingController(
        text: '0.0',
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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                OutlinedTextField(controller: _nameController, label: 'NOME'),
                OutlinedTextField(
                  controller: _descriptionController,
                  label: 'DESCRIZIONE',
                  allowMultipleLines: true,
                  inputType: TextInputType.multiline,
                  inputAction: TextInputAction.newline,
                ),
                Wrap(
                  children: _getPriceFields(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton.icon(
                      onPressed: _aggiungiPrezzo,
                      icon: const Icon(Icons.add),
                      label: const Text('€'),
                    ),
                    FilledButton.icon(
                      onPressed: _rimuoviPrezzo,
                      icon: const Icon(Icons.remove),
                      label: const Text('€'),
                    ),
                  ],
                ),
                allergeniController,
                FloatingActionButton(
                  onPressed: () {
                    translateProduct(context, _descriptionController.text,
                        _nameController.text);
                  },
                  child: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _aggiungiPrezzo() {
    if (_priceFields.length < 3) {
      setState(() {
        final controller = TextEditingController(text: '0.0');
        _priceControllerList.add(controller);
        final c = Container(
          margin: const EdgeInsets.all(8.0),
          width: 80,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text('prezzo')),
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

  List<Widget> _getPriceFields() {
    if (_priceFields.isEmpty) {
      _priceFields.add(Container(
        margin: const EdgeInsets.all(8.0),
        width: 80,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text('prezzo')),
          controller: _priceControllerList[0],
        ),
      ));
    }
    return _priceFields;
  }

  Future<void> translateProduct(
    BuildContext context,
    String descrizione,
    String nome,
  ) async {
    final translator = GoogleTranslator();
    final Map<String, String> descrizioni = {'it': _descriptionController.text};
    if (descrizione.isNotEmpty) {
      toastification.show(
          title: const Text('Inizo la traduzione...'),
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.info);
      for (String lingua in descrizioni.keys) {
        if (descrizioni[lingua] == '') {
          toastification.show(
              title: Text('traduco in $lingua...'),
              style: ToastificationStyle.flat,
              autoCloseDuration: const Duration(seconds: 3),
              type: ToastificationType.info);
          final translatedText =
              await translator.translate(descrizione, from: 'it', to: lingua);
          descrizioni.putIfAbsent(lingua, () => translatedText.text);
        }
      }
      toastification.dismissAll();
    }

    if (context.mounted) {
      BlocProvider.of<ProductBloc>(context).add(
        SaveProductEvent(
          product: Product(
              nome: nome,
              descrizioni: descrizioni,
              type: widget.type,
              prezzi: _priceControllerList
                  .map(
                    (e) => double.tryParse(e.text) ?? 0.0,
                  )
                  .toList(),
              allergeni: allergeniController.allergeniList),
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
