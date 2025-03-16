import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({super.key, required this.controller, required this.label});

  final String label;
  final TextEditingController controller;
  static const _textFieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(),
  );
  static const _padding =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: TextField(
        decoration: _textFieldInputDecoration.copyWith(label: Text(label)),
        controller: controller,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
