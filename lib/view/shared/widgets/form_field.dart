import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefaultFormField extends StatelessWidget {
  DefaultFormField(
      {required this.controller,
      this.fillHint,
      required this.title,
      required this.prefix,
      this.isPass = false,
      this.validator,
      this.keyboardType,
      this.suffix,
      this.border = false,
      Key? key})
      : super(key: key);

  bool border;
  TextEditingController controller;
  String? fillHint;
  String title;
  IconData prefix;
  bool isPass = false;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;
  Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      autofillHints: fillHint == null ? null : [fillHint!],
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: border
            ? OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorManager.darkGrey.withOpacity(0.4), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        suffixIcon: suffix,
        prefixIcon: Icon(
          prefix,
          size: 20,
          color: ColorManager.mainBlue,
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
