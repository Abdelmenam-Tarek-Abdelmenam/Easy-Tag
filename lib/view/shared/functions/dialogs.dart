import 'package:flutter/material.dart';

void customChoiceDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Function yesFunction,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              OutlinedButton(
                  //  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "no",
                    style: TextStyle(color: Colors.green),
                  )),
              OutlinedButton(
                  //isDefaultAction: true,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    yesFunction();
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ));
}
