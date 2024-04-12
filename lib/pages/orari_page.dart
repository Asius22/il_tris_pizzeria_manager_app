import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/bloc/businesshours_bloc.dart';
import 'package:il_tris_manager/components/business_hours_components/day_card.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:pizzeria_model_package/business_hours.dart';
import 'package:pizzeria_model_package/opening_hours.dart';
import 'package:pizzeria_model_package/opening_hours_list.dart';

class OrariPage extends StatelessWidget {
  const OrariPage({super.key});

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
    BusinesshoursBloc provider = BlocProvider.of<BusinesshoursBloc>(context);
    return Scaffold(body: BlocBuilder<BusinesshoursBloc, BusinesshoursState>(
      builder: (context, state) {
        log("[DEBUG] ORARI PAGE: COSTURUISCO");
        if (state is InitialBusinesshoursState) {
          log("[DEBUG] ORARI PAGE: INIZIALIZZAZIONE");

          BlocProvider.of<BusinesshoursBloc>(context)
              .add(InitializeBusinessHoursEvent());
          return const WaitingPage();
        } else if (state is InitializingBusinesshoursState) {
          log("[DEBUG] ORARI PAGE: INIZIALIZZANDO...");

          return const WaitingPage();
        } else {
          log("[DEBUG] ORARI PAGE: INIZIALIZZAZIONE COMPLETA");

          BusinessHours giorni =
              (state as InitializedBusinesshoursState).businessHours;

          List<String> sortedkeys = giorni.days
            ..sort(
              (a, b) {
                if (ordine.containsKey(a)) {
                  if (ordine.containsKey(b)) {
                    // se [a]è presente ma b no allora [b] deve stare dopo, altrimenti dipende dal loro peso
                    return ordine[a]! - ordine[b]!;
                  } else {
                    return -1;
                  }
                } else if (ordine.containsKey(b)) {
                  return 1;
                } else {
                  log(a);
                }
                return -1;
              },
            );

          return RefreshIndicator(
            onRefresh: () {
              provider.add(InitializeBusinessHoursEvent());
              return Future.delayed(Duration.zero);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: giorni.daysLenght + 1,
                itemBuilder: (context, index) {
                  return index < giorni.daysLenght
                      ? DayCard(
                          giorno: sortedkeys[index],
                          orariApertura: giorni.daysMap[sortedkeys[index]] ??
                              OpeningHoursList(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FilledButton(
                              style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)))),
                              onPressed: () async {
                                DateTime giorno = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(
                                            DateTime.now().year + 20)) ??
                                    DateTime.now();
                                provider.add(
                                  AddBusinessHoursEvent(
                                    giorno.toString().substring(0, 10),
                                    const OpeningHours(
                                        startHour: "00:00", endHour: "00:01"),
                                  ),
                                );
                              },
                              child:
                                  const Text("Aggiungi apertura straordinaria"),
                            ),
                            FilledButton(
                              style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)))),
                              onPressed: () {
                                provider.add(SaveAllBusinessHoursEvent(giorni));
                              },
                              child: const Text("Salva tutto!"),
                            ),
                          ],
                        );
                },
              ),
            ),
          );
        }
      },
    ));
  }

  BusinessHours _ordinaGiorni(BusinessHours base) {
    const List<String> ordine = [
      "lunedì",
      "martedì",
      "mercoledì",
      "giovedì",
      "venerdì",
      "sabato",
      "domenica"
    ];

    Map<String, OpeningHoursList> res = {};

    for (String key in ordine) {
      res.putIfAbsent(key, () => base.daysMap[key]!);
    }

    for (String s in base.days) {
      if (!res.containsKey(s)) {
        res.putIfAbsent(s, () => base.daysMap[s]!);
      }
    }

    return BusinessHours.fromDays(daysMap: res);
  }
}
