import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:pizzeria_model_package/model/product.dart';

class AllergeniSelectList extends StatelessWidget {
  AllergeniSelectList({super.key, this.selectedIndices});
  static final allergeniNames = allergeni.keys.toList();
  final List<int>? selectedIndices;
  final ChipList _chiplist = ChipList(
    listOfChipNames: allergeniNames,
    listOfChipIndicesCurrentlySelected: [],
    supportsMultiSelect: true,
    shouldWrap: true,
    activeBorderColorList: [Colors.black],
    inactiveBgColorList: [Colors.blueGrey],
    inactiveBorderColorList: [Colors.blueGrey],
    inactiveTextColorList: [Colors.white],
  );

  List<Allergene> get allergeniList =>
      _chiplist.listOfChipIndicesCurrentlySelected
          .map((keyIndex) => allergeni[allergeniNames[keyIndex]]!)
          .toList();

  @override
  Widget build(BuildContext context) {
    _chiplist.listOfChipIndicesCurrentlySelected = selectedIndices ?? [];
    return _chiplist..listOfChipIndicesCurrentlySelected;
  }
}
