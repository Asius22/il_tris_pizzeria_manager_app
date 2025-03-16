import 'package:flutter/material.dart';
import 'package:il_tris_manager/pages/menu_bloc_page.dart';
import 'package:il_tris_manager/pages/orari_page.dart';
import 'package:il_tris_manager/pages/query_page.dart';
import 'package:sizer/sizer.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const String routeName = "/";
  static const Map<String, String> actions = {
    "MODIFICA MENU": MenuBlocPage.routeName,
    "Modifica Orari": OrariPage.routeName,
    "Esegui query": QueryPage.routeName,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          children: actions.keys
              .map(
                (titolo) => FilledButton(
                  style: ButtonStyle(
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
              )
              .toList(),
        ),
      ),
    );
  }
}
