import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  const OutlinedTextField(
      {super.key,
      required this.label,
      this.icon,
      this.initialText,
      this.controller,
      this.padding,
      this.allowMultipleLines = false,
      this.inputAction = TextInputAction.done,
      this.inputType = TextInputType.text});
  final TextInputAction inputAction;
  final String label;
  final TextInputType inputType;
  final TextEditingController? controller;
  final Widget? icon;
  final String? initialText;
  final EdgeInsets? padding;
  final bool allowMultipleLines;

  @override
  State<OutlinedTextField> createState() => OutlinedTextFieldState();
}

class OutlinedTextFieldState extends State<OutlinedTextField> {
  late final InputDecoration _decoration;
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);

    _decoration = InputDecoration(
        prefixIcon: widget.icon,
        focusedErrorBorder: const OutlineInputBorder(),
        errorBorder: const OutlineInputBorder(),
        border: const OutlineInputBorder(),
        label: Text(widget.label));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get value => _controller.text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      child: TextField(
        textInputAction: widget.inputAction,
        controller: _controller,
        maxLines: widget.allowMultipleLines ? null : 1,
        keyboardType: widget.inputType,
        decoration: _decoration.copyWith(
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.error))),
      ),
    );
  }
}
