import 'package:flutter/material.dart';

class Instructor {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String get name => nameController.text;
  String get email => emailController.text;
}
