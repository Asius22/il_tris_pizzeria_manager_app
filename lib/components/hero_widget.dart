import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    super.key,
    required this.heroTag,
    required this.child,
  });

  final String heroTag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        child: child,
      ),
    );
  }
}
