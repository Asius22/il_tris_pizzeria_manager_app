import 'package:flutter/material.dart';
import 'package:pizzeria_model_package/model/opening_hours.dart';

class OrariCard extends StatefulWidget {
  const OrariCard({
    super.key,
    required this.giorno,
    required this.orari,
    required this.onOrariChanged,
  });

  final String giorno;
  final List<OpeningHours> orari;
  final Function(List<OpeningHours>) onOrariChanged;

  @override
  State<OrariCard> createState() => _OrariCardState();
}

class _OrariCardState extends State<OrariCard> {
  late List<OpeningHours> _orariLocali;

  @override
  void initState() {
    super.initState();
    _orariLocali = List.from(widget.orari);
  }

  @override
  void didUpdateWidget(OrariCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orari != widget.orari) {
      _orariLocali = List.from(widget.orari);
    }
  }

  void _toggleAperto(bool value) {
    setState(() {
      if (value && _orariLocali.isEmpty) {
        // Aggiungi una fascia oraria di default
        _orariLocali.add(const OpeningHours(
          startHour: '08:00',
          endHour: '18:00',
        ));
      } else if (!value) {
        // Rimuovi tutte le fasce orarie
        _orariLocali.clear();
      }
    });
  }

  void _aggiungiFasciaOraria() {
    // Determine default times based on last entry
    String startHour = '12:00';
    String endHour = '15:00';

    if (_orariLocali.isNotEmpty) {
      final lastFascia = _orariLocali.last;
      // Try to add 30 minutes to the last end time
      final lastEndHour = int.parse(lastFascia.endHour.split(':')[0]);
      final lastEndMinute = int.parse(lastFascia.endHour.split(':')[1]);

      int newStartHour = lastEndHour;
      int newStartMinute = lastEndMinute + 30;

      if (newStartMinute >= 60) {
        newStartHour = (newStartHour + 1) % 24;
        newStartMinute = newStartMinute - 60;
      }

      startHour =
          '${newStartHour.toString().padLeft(2, '0')}:${newStartMinute.toString().padLeft(2, '0')}';

      // End time is start time + 3 hours
      final int newEndHour = (newStartHour + 3) % 24;
      endHour =
          '${newEndHour.toString().padLeft(2, '0')}:${newStartMinute.toString().padLeft(2, '0')}';
    }

    setState(() {
      _orariLocali.add(OpeningHours(
        startHour: startHour,
        endHour: endHour,
      ));
    });
  }

  void _rimuoviFasciaOraria(int index) {
    setState(() {
      _orariLocali.removeAt(index);
    });
  }

  Future<void> _modificaOrario(int index, bool isStartTime) async {
    final OpeningHours fascia = _orariLocali[index];
    final String orarioAttuale =
        isStartTime ? fascia.startHour : fascia.endHour;

    // Parse current time
    final timeParts = orarioAttuale.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    // Show time picker
    final TimeOfDay? nuovoOrario = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return child!;
      },
    );

    if (nuovoOrario != null) {
      setState(() {
        final formattedHour = nuovoOrario.hour.toString().padLeft(2, '0');
        final formattedMinute = nuovoOrario.minute.toString().padLeft(2, '0');
        final nuovoOrarioString = '$formattedHour:$formattedMinute';

        if (isStartTime) {
          _orariLocali[index] = OpeningHours(
            startHour: nuovoOrarioString,
            endHour: fascia.endHour,
          );
        } else {
          _orariLocali[index] = OpeningHours(
            startHour: fascia.startHour,
            endHour: nuovoOrarioString,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fasceSummary = _orariLocali
        .map((fascia) => '${fascia.startHour} - ${fascia.endHour}')
        .join(', ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(widget.giorno),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _orariLocali.isNotEmpty
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _orariLocali.isNotEmpty ? 'Aperto' : 'Chiuso',
                style: TextStyle(
                  color: _orariLocali.isNotEmpty
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        subtitle: fasceSummary.isNotEmpty ? Text(fasceSummary) : null,
        children: [
          SwitchListTile(
            title: const Text('Aperto'),
            value: _orariLocali.isNotEmpty,
            onChanged: _toggleAperto,
          ),
          if (_orariLocali.isNotEmpty) ...[
            for (int i = 0; i < _orariLocali.length; i++)
              _buildFasciaOraria(_orariLocali[i], i),
          ],
          ListTile(
            title: const Text('Aggiungi fascia oraria'),
            leading: const Icon(Icons.add_circle_outline),
            onTap: _aggiungiFasciaOraria,
            trailing: IconButton(
              icon: const Icon(
                Icons.check,
              ),
              onPressed: () => widget.onOrariChanged(_orariLocali),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFasciaOraria(OpeningHours fascia, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _modificaOrario(index, true),
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
              onTap: () => _modificaOrario(index, false),
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
            onPressed: () => _rimuoviFasciaOraria(index),
          ),
        ],
      ),
    );
  }
}
