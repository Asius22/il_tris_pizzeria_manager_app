import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {super.key, this.currentIndex = 0, this.pageController});
  final int currentIndex;
  final PageController? pageController;
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late int currentIndex;
  @override
  void initState() {
    currentIndex = widget.currentIndex;

    super.initState();
  }

  void _onTap(int newIndex) async {
    setState(() {
      currentIndex = newIndex;
      widget.pageController?.animateToPage(newIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedIconTheme: const IconThemeData(
        size: 28.0,
      ),
      selectedLabelStyle:
          const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      unselectedIconTheme: const IconThemeData(size: 20),
      unselectedItemColor: Theme.of(context).colorScheme.tertiary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          label: 'Query',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Orari'),
      ],
      onTap: _onTap,
    );
  }
}
