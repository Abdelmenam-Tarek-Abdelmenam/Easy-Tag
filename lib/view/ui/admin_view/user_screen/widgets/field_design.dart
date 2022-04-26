import 'package:flutter/material.dart';

import '../../../../resources/color_manager.dart';

class FieldDesign extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  const FieldDesign(
      {required this.title, required this.body, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(title);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: ColorManager.mainBlue,
            size: 20,
          ),
          const SizedBox(
            width: 25,
          ),
          Text(
            "$title : ",
            style: const TextStyle(
                color: ColorManager.mainBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(child: SelectableText(body))
        ],
      ),
    );
  }
}
