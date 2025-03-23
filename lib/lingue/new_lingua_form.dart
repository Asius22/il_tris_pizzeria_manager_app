import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/text_fields/outlined_textfield.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:toastification/toastification.dart';

class NewLinguaForm extends StatefulWidget {
  const NewLinguaForm({super.key});

  @override
  State<NewLinguaForm> createState() => NewLinguaFormState();
}

class NewLinguaFormState extends State<NewLinguaForm> {
  late final TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        spacing: 32,
        children: [
          Text(
            'Lingue presenti:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Wrap(
            children: BlocProvider.of<ProductBloc>(context)
                .lingue
                .map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        e.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ))
                .toList(),
          ),
          OutlinedTextField(
            label: 'Lingua',
            controller: controller,
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              OutlinedButton(
                  onPressed: () {
                    if (RegExp(r'^([A-Za-z]{2})$').hasMatch(controller.text)) {
                      toastification.show(
                          title: const Text('Aggiungi lingue al menu...'),
                          style: ToastificationStyle.flat,
                          autoCloseDuration: const Duration(seconds: 5),
                          type: ToastificationType.info);
                      BlocProvider.of<ProductBloc>(context)
                          .add(AddNewLanguageEvent(newLan: controller.text));
                    }
                  },
                  child: const Text('Salva')),
            ],
          ),
        ],
      ),
    );
  }
}
