import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/menu/allergeni_select_list.dart';
import 'package:il_tris_manager/components/menu/price_widget.dart';
import 'package:il_tris_manager/components/text_fields/outlined_textfield.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';

class DetailProductForm extends StatefulWidget {
  const DetailProductForm({super.key, required this.product});
  final Product product;
  @override
  State<DetailProductForm> createState() => DetailProductFormState();
}

class DetailProductFormState extends State<DetailProductForm> {
  late final TextEditingController _descrizioneController;
  late final TextEditingController _controllerNome;
  final List<Widget> _priceWidgetList = [];
  late Product _product;
  final List<TextEditingController> _priceControllerList = [];
  late final AllergeniSelectList allergeniWidget;
  @override
  void initState() {
    final allergeniNamed = allergeni.keys.toList();
    allergeniWidget = AllergeniSelectList(
      selectedIndices: [
        ...widget.product.allergeni.map(
          (e) => allergeniNamed.indexOf(e.name),
        )
      ],
    );
    _product = widget.product;
    // crea controllers
    _descrizioneController =
        TextEditingController(text: _product.descrizioni["it"]);

    _controllerNome = TextEditingController(text: _product.nome);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        OutlinedTextField(
          label: "Nome",
          controller: _controllerNome,
        ),
        OutlinedTextField(
          label: "Descrizione",
          controller: _descrizioneController,
        ),
        Row(
          children: _getPriceWidgets(),
        ),
        Row(
          children: [
            FilledButton.icon(
              onPressed: _aggiungiPrezzo,
              icon: const Icon(Icons.add),
              label: const Text("€"),
            ),
            FilledButton.icon(
              onPressed: _rimuoviPrezzo,
              icon: const Icon(Icons.remove),
              label: const Text("€"),
            ),
          ],
        ),
        allergeniWidget,
        FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () => _saveProductUpdate(context),
        )
      ],
    );
  }

  ///crea i vari widget per i prezzi
  List<Widget> _getPriceWidgets() {
    if (_priceWidgetList.isEmpty) {
      for (double d in widget.product.prezzi) {
        final controller = TextEditingController(text: "$d");
        _priceControllerList.add(controller);

        _priceWidgetList.add(PriceWidget(controller: controller));
      }
    }
    return _priceWidgetList;
  }

  void _aggiungiPrezzo() {
    if (_priceWidgetList.length < 3) {
      setState(() {
        final controller = TextEditingController(text: "0.0");
        _priceControllerList.add(controller);

        _priceWidgetList.add(PriceWidget(controller: controller));
      });
    }
  }

  void _rimuoviPrezzo() {
    if (_priceWidgetList.length > 1) {
      _priceControllerList.last.dispose();
      _priceControllerList.removeLast();
      setState(() {
        _priceWidgetList.removeLast();
      });
    }
  }

  ///legge i controller dei vari prezzi e crea una lista di valori
  List<double> _getPricesList() {
    List<double> res = [];
    for (TextEditingController c in _priceControllerList) {
      double d = double.parse(c.text.replaceAll(",", "."));
      if (d > 0) {
        res.add(d);
      }
    }
    return res;
  }

  Product get productUpdated => Product(
      nome: _controllerNome.text,
      descrizioni: widget.product.descrizioni
        ..update(
          "it",
          (value) => _descrizioneController.text,
        ),
      type: widget.product.type,
      allergeni: allergeniWidget.allergeniList,
      prezzi: _getPricesList());

  void _saveProductUpdate(BuildContext context) {
    Product p = productUpdated;
    if (p != widget.product) {
      BlocProvider.of<ProductBloc>(context)
          .add(UpdateProductEvent(newProduct: p, key: p.nome));
      Navigator.of(context).pop();
    }
  }
}
