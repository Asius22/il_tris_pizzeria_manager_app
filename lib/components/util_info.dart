import 'package:flutter/rendering.dart';

final password = RegExp(
    r"^([A-Za-z0-9@\[\]\-\_\.\;\:\,\!\'\£\$\%\&\/\(\)\=\?\^\ì\\\|]*[A-Z]+[A-Za-z0-9@\[\]\-\_\.\;\:\,\!\'\£\$\%\&\/\(\)\=\?\^\ì\\\|]*[a-z]+[A-Za-z0-9@\[\]\-\_\.\;\:\,\!\'\£\$\%\&\/\(\)\=\?\^\ì\\\|]*[0-9]+[A-Za-z0-9@\[\]\-\_\.\;\:\,\!\'\£\$\%\&\/\(\)\=\?\^\ì\\\|]*[@\[\]\-\_\.\;\:\,\!\'\£\$\%\&\/\(\)\=\?\^\ì\\\|]+[A-Za-z0-9@\[\]\-\_\.\;\:\,\!\'\£\$\%\&\/\(\)\=\?\^\ì\\\|]*)$");
final email =
    RegExp(r"^[A-Za-z0-9\-\_\.]+@[A-Za-z]+(.[A-Za-z]+)*.[A-Za-z]{2,4}$");

const animationDuration = Duration(milliseconds: 300);
const List<String> typeList = [
  "Antipasto",
  "Pizza",
  "Panuozzo",
  "Bibita",
  "Frittura",
  "Dolce",
  "Primo",
  "Secondo",
  "Vino"
];

const imageRectRadius = BorderRadius.all(Radius.circular(16.0));
const primaryPadding = EdgeInsets.all(8.0);
const secondaryPAdding = EdgeInsets.all(4.0);
