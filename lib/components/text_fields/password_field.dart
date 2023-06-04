import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:il_tris_manager/components/text_fields/show_password_button.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  late final TextEditingController _controller;
  final InputDecoration _decoration = const InputDecoration(
    border: OutlineInputBorder(),
    label: Text("Password"),
  );
  bool _obscureText = true;

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

  void _showBtnClicked() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        obscureText: _obscureText,
        controller: _controller,
        validator: (value) {
          if (mounted && value != null) {
            if (value.isEmpty) {
              return "Il campo password non può essere vuoto";
            }

            if (value.length < 8) {
              return "La password deve essere lunga almeno 8 caratteri";
            }
            if (!password.hasMatch(value)) {
              log(value);
              return "la password deve contenere almeno una lettera maiuscola, una minuscola, un numero ed un carattere speciale";
            }

            return null;
          }
          return "La mail non può essere vuota";
        },
        decoration: _decoration.copyWith(
          suffixIcon: ShowPasswordBtn(onClick: _showBtnClicked),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}
