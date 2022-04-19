import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../resources/color_manager.dart';

class NumericField extends StatelessWidget {
  final TextEditingController controller;
  const NumericField(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return "cannot be empty";
        } else {
          int? isDigitsOnly = int.tryParse(value);
          return isDigitsOnly == null || isDigitsOnly == 0
              ? 'Integer only'
              : null;
        }
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: IconButton(
            icon: Icon(
              FontAwesomeIcons.minus,
              size: 20,
              color: Colors.red.withOpacity(0.5),
            ),
            onPressed: () {
              int d = int.parse(controller.text);
              if (d > 1) {
                d--;
                controller.text = "$d";
              }
            },
          ),
          suffixIcon: IconButton(
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 20,
              color: ColorManager.mainOrange.withOpacity(0.5),
            ),
            onPressed: () {
              int d = int.parse(controller.text);
              d++;
              controller.text = "$d";
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorManager.darkGrey.withOpacity(0.4), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}
