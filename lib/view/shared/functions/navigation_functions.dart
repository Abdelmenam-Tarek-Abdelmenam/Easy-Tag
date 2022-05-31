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

void navigateAndReplaceNormal(BuildContext context, Widget newScreen) {
  Navigator.pushReplacement(context,createRoute(newScreen));
}

void navigateAndPush(BuildContext context, Widget newScreen) {
  Navigator.of(context).push( createRoute(newScreen) );
 }
// void navigateAndPush(BuildContext context, Widget newScreen) {
//   Navigator.of(context).push( MaterialPageRoute(
//     builder: (_) => newScreen,
//   ));
// }

Route createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}