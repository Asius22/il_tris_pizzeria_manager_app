import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/orari/orari_card.dart';
import 'package:pizzeria_model_package/blocs/businesshours/businesshours_bloc.dart';
import 'package:pizzeria_model_package/model/business_hours.dart';

class OrariList extends StatelessWidget {
  const OrariList({super.key, required this.calendario, required this.giorni});
  final BusinessHours calendario;
  final List<String> giorni;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: giorni.length,
      itemBuilder: (context, index) {
        final String key = giorni[index];
        return OrariCard(
          giorno: key,
          orari: calendario.hoursMap[key]!,
          onOrariChanged: (p0) {
            log("$p0 cambiato");
            BlocProvider.of<BusinesshoursBloc>(context)
                .add(UpdateBusinessHoursEvent(key, p0));
          },
        );
      },
    );
  }
}
