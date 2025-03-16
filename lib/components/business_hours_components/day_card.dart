import 'dart:developer';
import 'package:pizzeria_model_package/blocs/businesshours/businesshours_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:il_tris_manager/components/text_fields/outlined_textfield.dart';
import 'package:pizzeria_model_package/model/opening_hours.dart';

class DayCard extends StatefulWidget {
  const DayCard({super.key, required this.giorno, required this.orariApertura});
  final String giorno;
  final List<OpeningHours> orariApertura;

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  final List<TextEditingController> _controllerList = [];
  bool chiusoValue = false;
  late List<OpeningHours> orari;
  @override
  void initState() {
    super.initState();
    orari = widget.orariApertura;
    chiusoValue = orari.isEmpty;
  }

  @override
  void dispose() {
    /*for (TextEditingController controller in _controllerList) {
      controller.dispose();
      _controllerList.remove(controller);
    }*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    BusinesshoursBloc provider = BlocProvider.of<BusinesshoursBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.giorno,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            children: [
              Checkbox(
                value: chiusoValue,
                onChanged: (value) => setState(() {
                  chiusoValue = !chiusoValue;

                  if (orari.isEmpty && !chiusoValue) {
                    orari.add(
                        OpeningHours(startHour: "00:00", endHour: "00:01"));
                  } else {
                    provider.add(UpdateBusinessHoursEvent(widget.giorno, []));
                  }
                }),
              ),
              const Text(
                "Chiuso",
                style: TextStyle(fontSize: 18),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              widget.giorno.contains("2")
                  ? IconButton(
                      onPressed: () {
                        provider.add(RemoveBusinessHoursEvent(widget.giorno));
                      },
                      icon: const Icon(Icons.delete))
                  : const SizedBox()
            ],
          ),
          !chiusoValue
              ? Column(children: [
                  ...getColumnElements(width),
                  FilledButton(
                      onPressed: () async {
                        bool? conferma = await showAdaptiveDialog<bool?>(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: const Text("Vuoi salvare questi orari?"),
                              actions: [
                                TextButton.icon(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    icon: const Icon(Icons.check),
                                    label: const Text("SI")),
                                TextButton.icon(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    icon: const Icon(Icons.close),
                                    label: const Text("NO")),
                              ]),
                        );
                        if (conferma != null && conferma) {
                          log("[DEBUG] SALVA");
                          List<OpeningHours> res = [];
                          for (int i = 0; i < _controllerList.length; i += 2) {
                            final tmp = OpeningHours(
                                startHour: _controllerList[i].text,
                                endHour: _controllerList[i + 1].text);
                            res.add(tmp);
                          }
                          provider.add(
                              UpdateBusinessHoursEvent(widget.giorno, res));
                        } else {
                          log("[DEBUG] NON SALVARE");
                        }
                      },
                      child: const Text("SALVA"))
                ])
              : const SizedBox()
        ],
      ),
    );
  }

  List<Widget> getColumnElements(double width) {
    List<Widget> res = [];

    for (int i = 0; i < orari.length; i++) {
      res.add(hoursFieldPair(width, i, orari[i]));
    }

    return res;
  }

  Widget hoursFieldPair(double width, int index, OpeningHours orario) {
    double fieldWidth = width * 0.8;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: fieldWidth,
          child: OutlinedTextField(
            controller: _getNewEditingController(ora: orario.startHour),
            label: "ora apertura",
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: fieldWidth,
              child: OutlinedTextField(
                controller: _getNewEditingController(ora: orario.endHour),
                label: "ora chiusura",
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (index == 0) {
                      orari.add(
                          OpeningHours(startHour: "00:00", endHour: "00:01"));
                    } else {
                      orari.remove(orario);
                    }
                  });
                  _controllerList.removeRange(0, _controllerList.length);
                },
                icon: Icon(index == 0 ? Icons.add : Icons.delete_outline))
          ],
        ),
      ],
    );
  }

  TextEditingController _getNewEditingController({String? ora}) {
    _controllerList.add(TextEditingController(text: ora ?? "00:00"));
    return _controllerList.last;
  }
}
