import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/components/orari/orari_list.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:pizzeria_model_package/blocs/businesshours/businesshours_bloc.dart';
import 'package:pizzeria_model_package/model/business_hours.dart';

class OrariBody extends StatelessWidget {
  const OrariBody({
    super.key,
    required this.controller,
    required this.onPageChanged,
  });
  static const String routeName = 'Orari';

  final PageController controller;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: onPageChanged,
      children: const [
        _OrariTab(
          storageKey: PageStorageKey<String>('orari-settimanali'),
          filtro: r'[A-Za-z]+',
        ),
        _OrariTab(
          storageKey: PageStorageKey<String>('orari-speciali'),
          filtro: r'\d+',
        ),
      ],
    );
  }
}

class _OrariTab extends StatelessWidget {
  const _OrariTab({
    required this.storageKey,
    required this.filtro,
  });

  final PageStorageKey<String> storageKey;
  final String filtro;

  static const Map<String, int> _ordine = {
    'lunedi': 0,
    'martedi': 1,
    'mercoledi': 2,
    'giovedi': 3,
    'venerdi': 4,
    'sabato': 5,
    'domenica': 6,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinesshoursBloc, BusinesshoursState>(
      builder: (context, state) {
        if (state is! InitializedBusinesshoursState) {
          return const WaitingPage();
        }

        final calendario = state.businessHours;

        return OrariList(
          storageKey: storageKey,
          calendario: calendario,
          giorni: _buildOrari(calendario, RegExp(filtro)),
        );
      },
    );
  }

  List<String> _buildOrari(BusinessHours calendario, RegExp filtro) {
    final res = calendario.days
        .where(
          (element) => element.contains(filtro),
        )
        .toList();

    return res
      ..sort(
        (a, b) {
          final aOrder = _ordine[_normalizeDay(a)];
          final bOrder = _ordine[_normalizeDay(b)];

          if (aOrder == null && bOrder == null) {
            return a.compareTo(b);
          }

          if (aOrder == null) {
            return 1;
          }

          if (bOrder == null) {
            return -1;
          }

          return aOrder - bOrder;
        },
      );
  }

  String _normalizeDay(String day) => day
      .toLowerCase()
      .replaceAll('\u00ec', 'i')
      .replaceAll('\u00ed', 'i')
      .replaceAll('\u00c3\u00ac', 'i')
      .replaceAll('\u00e8', 'e')
      .replaceAll('\u00e9', 'e');
}
