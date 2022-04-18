import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/device_config/widgets/main_widget.dart';
import 'package:flutter/material.dart';

class SendConfigScreen extends StatelessWidget {
  const SendConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorManager.whiteColor,
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              topWidget(),
              const SizedBox(
                height: 40,
              ),
              MainConfigWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget topWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Device configuration",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: ColorManager.mainOrange),
          ),
          SizedBox(
            height: 20,
          ),
          Text.rich(
              TextSpan(text: 'Connect to WI-FI', children: <InlineSpan>[
                TextSpan(
                  text: ' EasyTag ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'With password',
                ),
                TextSpan(
                  text: ' 88888888',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ColorManager.darkGrey)),
        ],
      ),
    );
  }
}
