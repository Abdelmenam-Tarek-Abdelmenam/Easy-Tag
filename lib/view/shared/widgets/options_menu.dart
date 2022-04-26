import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/admin_view/device_config/esp_config.dart';
import '../functions/navigation_functions.dart';

Widget optionsWidget(BuildContext context) {

  return PopupMenuButton<String>(
    color: Colors.red,
    onSelected: (index) {
      if (index == 'Configurations') {
        navigateAndPush(context, const SendConfigScreen());
      } else if (index == 'Logout') {

      }
    },
    itemBuilder: (BuildContext context) {
      return {'Configurations','Logout'}.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Row(
            children: [
                  const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              Text(choice),
            ],
          ),
        );
      }).toList();
    },
  );
}
