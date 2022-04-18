import 'package:flutter/material.dart';

void navigateAndReplace(BuildContext context, Widget newScreen) {
  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => newScreen,
    ),
    (route) => false,
  );
}

void navigateAndPush(BuildContext context, Widget newScreen) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => newScreen,
  ));
}
