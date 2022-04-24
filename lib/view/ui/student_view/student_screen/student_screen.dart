import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/student_view/student_screen/widgets/main_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../start_screen/signing/login_screen.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: ColorManager.mainBlue,
              height: 140,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 70, right: 20),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: ColorManager.whiteColor,
                child: userPhoto(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 110),
            child: SizedBox(
              width: 205,
              child: Text("App user",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ColorManager.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 140),
            child: SizedBox(
              width: 205,
              child: Text("App user",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: UserScreenLayout(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                        navigateAndReplace(context, const LoginView());
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget userPhoto({String? url}) {
    url = url ??
        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D";
    return ClipOval(
      child: FadeInImage.assetNetwork(
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 100),
        width: 100,
        placeholder: 'images/avatar.png',
        imageErrorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Image.asset(
            'images/avatar.png',
            width: 100,
            fit: BoxFit.fill,
          );
        },
        image: url,
      ),
    );
  }
}
