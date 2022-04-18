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
      Key? key})
      : super(key: key);

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
        suffixIcon: suffix,
        prefixIcon: Icon(
          prefix,
          size: 20,
          color: ColorManager.mainOrange,
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
