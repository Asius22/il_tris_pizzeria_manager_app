import 'package:flutter/material.dart';
import 'package:pizzeria_model_package/product.dart';

class DetailProductForm extends StatefulWidget {
  const DetailProductForm({super.key, required this.product});
  final Product product;
  @override
  State<DetailProductForm> createState() => DetailProductFormState();
}

class DetailProductFormState extends State<DetailProductForm> {
  late final TextEditingController _controllerDescrizione;
  late final TextEditingController _controllerDescrizioneEn;
  late final TextEditingController _controllerDescrizioneFr;
  late final TextEditingController _controllerDescrizioneDe;
  late final TextEditingController _controllerNome;
  final List<Widget> _priceWidgetList = [];
  late Product _product;
  final List<TextEditingController> _priceControllerList = [];
  @override
  void initState() {
    _product = widget.product;
    //! crea
    _controllerDescrizione = TextEditingController(text: _product.descrizione);
    _controllerDescrizioneEn =
        TextEditingController(text: _product.descrizioneEn);
    _controllerDescrizioneFr =
        TextEditingController(text: _product.descrizioneFr);
    _controllerDescrizioneDe =
        TextEditingController(text: _product.descrizioneDe);
    _controllerNome = TextEditingController(text: _product.nome);

    super.initState();
  }

  @override
  void dispose() {
    _controllerDescrizione.dispose();
    _controllerDescrizioneEn.dispose();
    _controllerDescrizioneFr.dispose();
    _controllerDescrizioneDe.dispose();
    _controllerNome.dispose();
    for (TextEditingController t in _priceControllerList) {
      t.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controllerDescrizioneEn,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("inglese"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controllerDescrizioneFr,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("francese"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controllerDescrizioneDe,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("tedesco"),
            ),
          ),
        ),
        Wrap(
          children: [..._getPriceWidgets()],
        ),
        Wrap(
          verticalDirection: VerticalDirection.down,
          runAlignment: WrapAlignment.center,
          direction: Axis.vertical,
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
            child: SizedBox(
          height: 100,
        ))
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
      descrizioneEn: _controllerDescrizioneEn.text,
      descrizioneFr: _controllerDescrizioneFr.text,
      descrizioneDe: _controllerDescrizioneDe.text,
      type: widget.product.type,
      prezzi: _getPricesList());
}
