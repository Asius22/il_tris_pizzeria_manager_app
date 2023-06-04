import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/util_info.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    super.key,
  });

  @override
  State<EmailField> createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  late final TextEditingController _controller;
  final InputDecoration _decoration = const InputDecoration(
    prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(),
    label: Text("Email"),
  );

  String get value => _controller.text;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (mounted && value != null) {
            if (value.isEmpty) {
              return "La mail non può essere vuota";
            }

            if (!email.hasMatch(value)) {
              return "La mail inserita non è valida";
            }
            return null;
          }
          return "La mail non può essere vuota";
        },
        decoration: _decoration.copyWith(
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}
