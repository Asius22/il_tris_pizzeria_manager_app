import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/navigation_bar.dart';
import 'package:il_tris_manager/pages/image_page.dart';
import 'package:il_tris_manager/pages/menu_bloc_page.dart';
import 'package:il_tris_manager/pages/orari_page.dart';
import 'package:il_tris_manager/pages/query_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.initialRoute});
  final int initialRoute;

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: initialRoute,
        pageController: pageController,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [MenuBlocPage(), ImagePage(), QueryPage(), OrariPage()],
      ),
    );
  }
}
