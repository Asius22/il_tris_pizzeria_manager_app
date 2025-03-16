import 'package:flutter/material.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      width: 80,
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), label: Text("prezzo")),
        controller: widget.controller,
      ),
    );
  }
}
