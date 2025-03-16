import 'package:flutter/material.dart';
import 'package:pizzeria_model_package/model/opening_hours.dart';

class FasciaOrariaTile extends StatelessWidget {
  const FasciaOrariaTile(
      {super.key,
      required this.fascia,
      required this.changeAction,
      required this.removeAction});
  final OpeningHours fascia;
  final Function(int, bool) changeAction;
  final Function(int) removeAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => changeAction(1, true),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Apertura',
                  border: OutlineInputBorder(),
                ),
                child: Text(fascia.startHour),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => changeAction(1, false),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Chiusura',
                  border: OutlineInputBorder(),
                ),
                child: Text(fascia.endHour),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => removeAction(1),
          ),
        ],
      ),
    );
  }
}
