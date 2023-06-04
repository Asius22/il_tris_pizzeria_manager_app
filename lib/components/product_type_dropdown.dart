import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/util_info.dart';

class ProductTypeDropdown extends StatefulWidget {
  const ProductTypeDropdown({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<ProductTypeDropdown> createState() => _ProductTypeDropdownState();
}

class _ProductTypeDropdownState extends State<ProductTypeDropdown> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
    for (String s in typeList) {
      dropdownMenuEntries.add(DropdownMenuEntry(value: s, label: s));
    }
    return DropdownMenu<String>(
      enableSearch: false,
      enableFilter: false,
      dropdownMenuEntries: dropdownMenuEntries,
      controller: widget.controller,
      initialSelection: "Pizza",
    );
  }
}
