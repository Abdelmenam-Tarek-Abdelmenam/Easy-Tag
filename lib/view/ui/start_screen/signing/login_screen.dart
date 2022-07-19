import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/string_manager.dart';
import 'package:auto_id/view/ui/start_screen/signing/widgtes/main_widget.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final Course? course;
  const LoginView({this.course, Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        bottomNavigationBar: Image.asset(
          'images/eme_logo.png',
          height: 50,
        ),
        backgroundColor: ColorManager.whiteColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: Colors.blue.withOpacity(0.1),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        StringManger.appName,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: ColorManager.mainBlue),
                      ),
                      Icon(Icons.nfc_rounded, size: 30)
                    ],
                  ),
                ),
                SizedBox(width: 450, child: MainLoginWidget(widget.course)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
