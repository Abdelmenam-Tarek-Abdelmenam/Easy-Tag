import 'package:flutter/material.dart';

import '../../../../resources/color_manager.dart';

class DurationButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final Color color;
  const DurationButton(
      {required this.onPressed,
      required this.icon,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 40,
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(color),
          backgroundColor: MaterialStateProperty.all(ColorManager.blackColor),
          fixedSize: MaterialStateProperty.all(const Size.square(50))),
    );
  }
}
