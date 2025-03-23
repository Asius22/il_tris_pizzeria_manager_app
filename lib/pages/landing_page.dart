import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/circle_widget.dart';
import 'package:il_tris_manager/pages/menu_bloc_page.dart';
import 'package:il_tris_manager/pages/orari_page.dart';
import 'package:il_tris_manager/pages/lingue_page.dart';
import 'package:sizer/sizer.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const String routeName = '/';
  static const Map<String, String> actions = {
    'Modifica Menu': MenuBlocPage.routeName,
    'Modifica Orari': OrariPage.routeName,
    'Aggiungi Lingua': LinguaPage.routeName,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        child: Stack(children: [
          Positioned(
            top: 40.h,
            left: -60.w,
            right: -60.w,
            child: CircleWidget(radius: 120.w),
          ),
          Positioned(
            top: 20.h,
            left: 10.w,
            right: 10.w,
            child: const Text(
              'GESTISCI DATI',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16,
                children: actions.keys
                    .map(
                      (titolo) => Container(
                        height: 128,
                        width: 128,
                        padding: const EdgeInsets.all(8),
                        child: FilledButton(
                          style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.of(context).pushNamed(actions[titolo]!),
                          child: Text(titolo),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
