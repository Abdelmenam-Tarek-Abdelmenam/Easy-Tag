import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/shared/widgets/powered_by_navigation_bar.dart';
import 'package:auto_id/view/ui/admin_view/device_config/widgets/main_widget.dart';
import 'package:flutter/material.dart';

class SendConfigScreen extends StatelessWidget {
  const SendConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: poweredBy(),
      appBar: appBar('Device Configuration'),
      // resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.blackColor.withOpacity(0.1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topWidget(),
          const SizedBox(
            height: 40,
          ),
          Center(child: SizedBox(
              width: 500,
              child: MainConfigWidget()))
        ],
      ),
    );
  }

  Widget topWidget() {
    return Stack(
      children: [

        Transform.translate(
          offset: const Offset(-50,0),
          child: Container(
            margin: const EdgeInsets.only(right: 50),
            decoration: BoxDecoration(
              color: Colors.deepOrange[300],
              borderRadius: BorderRadius.circular(80),
            ),
            child: const SizedBox(width: 300,height: 85,)
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 10),
          child: Text.rich(
              TextSpan(
                  style: TextStyle(color: Colors.white,fontSize: 18),
                  text: 'Note', children: <InlineSpan>[
                TextSpan(
                  text: ' \nConnect to WI-FI ',
                ),
                TextSpan(
                  text: ' EasyTag ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' \nwith password ',
                ),
                TextSpan(
                  text: ' 88888888 ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ColorManager.darkGrey)),
        ),
      ],
    );
  }
}
