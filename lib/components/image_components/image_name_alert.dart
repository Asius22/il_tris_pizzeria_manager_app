import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/text_fields/outlined_textfield.dart';

class ImageRenameAlert extends StatelessWidget {
  ImageRenameAlert({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(""),
          child: const Text("Cancella"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text("Conferma"),
        ),
      ],
      content: OutlinedTextField(
        label: "nome",
        padding: const EdgeInsets.all(4.0),
        controller: controller,
      ),
    );
  }
}
