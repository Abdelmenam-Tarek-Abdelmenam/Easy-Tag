import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/student_view/student_screen/widgets/main_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../start_screen/signing/login_screen.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Profile',actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton.icon(
            onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            navigateAndReplace(context, const LoginView());
          },
              icon: const Icon(Icons.logout,size: 20,),
              label:  const Text('Logout'),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),
              foregroundColor: MaterialStateProperty.all(Colors.white))),
        ),
        ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black12,
                    height: 80,
                  ),
                  const Positioned(
                    left: 10, top: 10,
                    child: Text("Ahmed Khaled ibrahem",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorManager.mainBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.w400)),
                  ),
                  const Positioned(
                    left: 10,top: 55,
                    child: Text("App User",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  ),
                  const Positioned(
                    left: 10,bottom: 50,
                    child: Text("ahmedkhaledibrahem@gmail.com",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                  ),
                  Positioned(
                    right: 10,top: 10,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: ColorManager.whiteColor,
                      child: userPhoto(),
                    ),
                  ),


                ],
              ),
            ),
            const UserScreenLayout()
          ],
        ),
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
