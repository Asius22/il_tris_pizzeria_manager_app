import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget(
      {super.key,
      required this.radius,
      this.secondary = true,
      this.opacity = 160});
  final double radius;
  final bool secondary;
  final int opacity;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: secondary
          ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(opacity)
          : Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(90),
    );
  }
}
