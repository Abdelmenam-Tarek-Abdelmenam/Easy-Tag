import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/shared/widgets/powered_by_navigation_bar.dart';
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
      bottomNavigationBar: poweredBy(),
      appBar: appBar('Profile', actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                navigateAndReplace(context, const LoginView());
              },
              icon: const Icon(
                Icons.logout,
                size: 20,
              ),
              label: const Text('Logout'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
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
                  Positioned(
                    left: 10,
                    top: 10,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(StudentDataBloc.student.name ?? "App User",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: ColorManager.mainBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 50,
                    child: Text(StudentDataBloc.student.email ?? "App User",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: ColorManager.whiteColor,
                      child: userPhoto(url: StudentDataBloc.student.photoUrl),
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
