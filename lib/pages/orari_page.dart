import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/orari/orari_body.dart';
import 'package:intl/intl.dart';
import 'package:pizzeria_model_package/blocs/businesshours/businesshours_bloc.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:pizzeria_model_package/model/business_hours.dart';
import 'package:pizzeria_model_package/model/opening_hours.dart';
import 'package:toastification/toastification.dart';

class OrariPage extends StatelessWidget {
  const OrariPage({super.key});
  static const String routeName = 'orari';

  @override
  Widget build(BuildContext context) {
    // Tab controller per le pagine a seguire
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Gestione Orari Apertura'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Orari Settimanali'),
                Tab(text: 'Aperture Speciali'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final now = DateTime.now();
              final date = await showDatePicker(
                  context: context,
                  firstDate: now,
                  lastDate: DateTime(now.year + 20));

              if (date != null) {
                if (context.mounted) {
                  BlocProvider.of<BusinesshoursBloc>(context).add(
                      AddBusinessHoursEvent(
                          DateFormat("dd-MM-yyyy").format(date), [
                    OpeningHours(startHour: "18:00", endHour: "23:55")
                  ]));
                } else {
                  toastification.show(
                      title: Text("Impossibile salvare, riprova più tardi"),
                      autoCloseDuration: Duration(seconds: 5),
                      style: ToastificationStyle.flatColored,
                      type: ToastificationType.error);
                }
              }
            },
            child: Icon(Icons.add),
          ),
          body: BlocBuilder<BusinesshoursBloc, BusinesshoursState>(
            builder: (context, state) {
              if (state is InitialBusinesshoursState) {
                BlocProvider.of<BusinesshoursBloc>(context)
                    .add(InitializeBusinessHoursEvent());
                return const WaitingPage();
              } else if (state is InitializingBusinesshoursState) {
                return const WaitingPage();
              } else {
                BusinessHours giorni =
                    (state as InitializedBusinesshoursState).businessHours;

                return OrariBody(
                  calendario: giorni,
                );
                //return OrariBody(chiavi: sortedkeys, giorni: giorni);
              }
            },
          )),
    );
  }
}
