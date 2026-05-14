import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/orari/orari_body.dart';
import 'package:intl/intl.dart';
import 'package:pizzeria_model_package/blocs/businesshours/businesshours_bloc.dart';
import 'package:pizzeria_model_package/model/opening_hours.dart';
import 'package:toastification/toastification.dart';

class OrariPage extends StatefulWidget {
  const OrariPage({super.key});
  static const String routeName = 'orari';

  @override
  State<OrariPage> createState() => _OrariPageState();
}

class _OrariPageState extends State<OrariPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    context.read<BusinesshoursBloc>().add(InitializeBusinessHoursEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_pageController.hasClients && _pageController.page?.round() == index) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    if (_tabController.index != index) {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestione Orari Apertura'),
        bottom: TabBar(
          controller: _tabController,
          onTap: _onTabSelected,
          tabs: const [
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
            lastDate: DateTime(now.year + 20),
          );

          if (date != null) {
            if (context.mounted) {
              context.read<BusinesshoursBloc>().add(
                    AddBusinessHoursEvent(
                      DateFormat('dd-MM-yyyy').format(date),
                      const [
                        OpeningHours(startHour: '18:00', endHour: '23:55')
                      ],
                    ),
                  );
            } else {
              toastification.show(
                title: const Text('Impossibile salvare, riprova piu tardi'),
                autoCloseDuration: const Duration(seconds: 5),
                style: ToastificationStyle.flatColored,
                type: ToastificationType.error,
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: OrariBody(
        controller: _pageController,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
