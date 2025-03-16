import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/orari/orari_list.dart';
import 'package:pizzeria_model_package/model/business_hours.dart';

class OrariBody extends StatelessWidget {
  const OrariBody({super.key, required this.calendario});
  static const String routeName = "Orari";

  final BusinessHours calendario;

  static const Map<String, int> ordine = {
    "lunedì": 0,
    "martedì": 1,
    "mercoledì": 2,
    "giovedì": 3,
    "venerdì": 4,
    "sabato": 5,
    "domenica": 6
  };

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        OrariList(
          calendario: calendario,
          giorni: _buildOrari(
            RegExp(r"[A-Za-z]+"),
          ),
        ), // Giorni settimanali non contengono numeri
        OrariList(
          calendario: calendario,
          giorni: _buildOrari(
            RegExp(r"\d+"),
          ),
        ), // Le date non contengono lettere
      ],
    );
  }

  List<String> _buildOrari(RegExp filtro) {
    List<String> res = calendario.days
        .where(
          (element) => element.contains(filtro),
        )
        .toList();

    return res
      ..sort(
        (a, b) {
          if (ordine.containsKey(a)) {
            // se [a] è presente ma b no allora [b] deve stare dopo, altrimenti dipende dal loro peso
            if (ordine.containsKey(b)) {
              return ordine[a]! - ordine[b]!;
            } else {
              return -1;
            }
          }

          return -1;
        },
      );
  }
}
