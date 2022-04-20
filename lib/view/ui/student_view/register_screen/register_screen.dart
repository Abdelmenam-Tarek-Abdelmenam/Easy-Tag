import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/ui/student_view/register_screen/widgets/register_fields.dart';
import 'package:flutter/material.dart';

import '../../../resources/color_manager.dart';

// List<String> columnsNames = const [
//   "ID",
//   "Name",
//   "Gender",
//   "Department",
//   "Image",
//   "Phone",
//   "second-Phone",
//   "Email",
//   "LinkedIn",
//   "Facebook",
//   "Address",
// ];
class RegisterScreen extends StatelessWidget {
  final Course course;
  const RegisterScreen(this.course, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 26,
                      color: ColorManager.mainBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55),
              child: RegisterField(course.columns),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorManager.mainBlue),
                        foregroundColor:
                            MaterialStateProperty.all(ColorManager.whiteColor)),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
