import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:il_tris_manager/components/product_type_dropdown.dart';
import 'package:il_tris_manager/components/text_fields/outlined_textfield.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({super.key});
  static const String routeName = "query";
  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  late final TextEditingController _typeController;
  late final TextEditingController _newPriceController;
  late final TextEditingController _oldPriceController;
  static const _padding = EdgeInsets.all(32);

  @override
  void initState() {
    _typeController = TextEditingController();
    _newPriceController = TextEditingController(text: "0.0");
    _oldPriceController = TextEditingController(text: "0.0");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
      child: Scaffold(body:Padding(
        padding: _padding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "UPDATE ",
                  style: textTheme,
                ),
                ProductTypeDropdown(controller: _typeController)
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "SET PREZZO =",
                  style: textTheme,
                ),
                Expanded(
                  child: OutlinedTextField(
                    label: "nuovo prezzo",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    controller: _newPriceController,
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "WHERE PREZZO =",
                  style: textTheme,
                ),
                Expanded(
                  child: OutlinedTextField(
                    label: "vecchio prezzo",
                    inputType: TextInputType.number,
                    controller: _oldPriceController,
                  ),
                )
              ],
            ),
            const Expanded(flex: 4, child: SizedBox()),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.all(16))),
                  onPressed: () => _executeBtnPressed(context),
                  icon: const Icon(Icons.send),
                  label: const Text(" E S E G U I "),
                ),
                ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.all(16))),
                  onPressed: () {
                    _oldPriceController.text = "0.0";
                    _newPriceController.text = "0.0";
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text(" R E S E T "),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  void _executeBtnPressed(BuildContext context) {
    String type = _typeController.text;
    double newPrice =
        double.tryParse(_newPriceController.text.replaceAll(",", ".")) ?? 0;
    double oldPrice =
        double.tryParse(_oldPriceController.text.replaceAll(",", ".")) ?? 0;
    if (newPrice > 0 && oldPrice > 0) {
      if (newPrice != oldPrice) {
        BlocProvider.of<ProductBloc>(context).add(UpdateAllProductEvent(
            newPrice: newPrice, oldPrice: oldPrice, type: type));
        log(
          "Richiesta inviata al server!",
        );
      } else {
        log(
          "Modifica inutile...",
        );
      }
    } else {
      log(
        "Riempi tutti i campi!",
      );
    }
  }
}
