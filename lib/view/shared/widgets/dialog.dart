import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> dialog(BuildContext context,{title,content,yes,no}) async {
  return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title??'Are you Sure'),
          content: Text(content??'you want Exit ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(no??'No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(yes??'Yes',style: const TextStyle(color: Colors.red),),
            ),
          ],
        ),
      )
  ) ?? false;
}