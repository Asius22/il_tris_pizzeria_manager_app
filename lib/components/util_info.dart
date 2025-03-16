import 'package:flutter/rendering.dart';
import 'package:pizzeria_model_package/model/product.dart';

const animationDuration = Duration(milliseconds: 400);
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

Map<String, Allergene> allergeni = {
  "arachidi": Allergene.arachidi,
  "crostacei": Allergene.crostacei,
  "glutine": Allergene.glutine,
  "gusci": Allergene.gusci,
  "latte": Allergene.latte,
  "lupini": Allergene.lupini,
  "molluschi": Allergene.molluschi,
  "pesce": Allergene.pesce,
  "sedano": Allergene.sedano,
  "senape": Allergene.senape,
  "sesamo": Allergene.sesamo,
  "soia": Allergene.soia,
  "solfiti": Allergene.solfiti,
  "surgelato": Allergene.surgelato,
  "uova": Allergene.uova,
};
