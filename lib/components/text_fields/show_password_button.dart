import 'package:flutter/material.dart';

class ShowPasswordBtn extends StatefulWidget {
  const ShowPasswordBtn({super.key, required this.onClick});
  final Function onClick;
  @override
  State<ShowPasswordBtn> createState() => _ShowPasswordBtnState();
}

class _ShowPasswordBtnState extends State<ShowPasswordBtn> {
  late bool isVisible;

  @override
  void initState() {
    isVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        setState(() {
          isVisible = !isVisible;
        });
        widget.onClick();
      },
      child: Icon(!isVisible
          ? Icons.visibility_outlined
          : Icons.visibility_off_rounded),
    );
  }
}
