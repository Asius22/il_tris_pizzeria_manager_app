import 'package:flutter/material.dart';
import 'package:il_tris_manager/model/product.dart';

class DetailProductForm extends StatefulWidget {
  const DetailProductForm({super.key, required this.product});
  final Product product;
  @override
  State<DetailProductForm> createState() => DetailProductFormState();
}

class DetailProductFormState extends State<DetailProductForm> {
  late final TextEditingController _controllerDescrizione;
  late final TextEditingController _controllerNome;
  final List<Widget> _priceWidgetList = [];
  late Product _product;
  final List<TextEditingController> _priceControllerList = [];
  @override
  void initState() {
    _product = widget.product;
    _controllerDescrizione = TextEditingController();
    _controllerNome = TextEditingController();
    _controllerDescrizione.text = _product.descrizione;
    _controllerNome.text = _product.nome;
    super.initState();
  }

  @override
  void dispose() {
    _controllerDescrizione.dispose();
    _controllerNome.dispose();
    for (TextEditingController t in _priceControllerList) {
      t.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controllerNome,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("nome"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controllerDescrizione,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("descrizione"),
            ),
          ),
        ),
        Row(
          children: [..._getPriceWidgets()],
        ),
        const Expanded(flex: 4, child: SizedBox()),
        Row(
          mainAxisSize: MainAxisSize.max,
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
        const Expanded(
          child: SizedBox(),
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
        final c = Container(
          margin: const EdgeInsets.all(16.0),
          width: 100,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.euro,
                size: 18,
              ),
            ),
            controller: controller,
          ),
        );
        _priceWidgetList.add(c);
      }
    }
    return _priceWidgetList;
  }

  void _aggiungiPrezzo() {
    if (_priceWidgetList.length < 3) {
      setState(() {
        final controller = TextEditingController(text: "0.0");
        _priceControllerList.add(controller);
        final c = Container(
          margin: const EdgeInsets.all(16.0),
          width: 80,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text("prezzo")),
            controller: controller,
          ),
        );
        _priceWidgetList.add(c);
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
      descrizione: _controllerDescrizione.text,
      type: widget.product.type,
      prezzi: _getPricesList());
}
