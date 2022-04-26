import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/student_view/details_screen/widgets/details_layout.dart';
import 'package:auto_id/view/ui/student_view/register_screen/register_screen.dart';
import 'package:flutter/material.dart';
import '../../../../model/module/course.dart';
import '../../../resources/color_manager.dart';
import '../../admin_view/edit_course/edit_course_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Course course;
  final bool enableRegister;

  const DetailsScreen(
    this.course, {
    this.enableRegister = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(40,50)),
              backgroundColor:
              MaterialStateProperty.all(ColorManager.mainBlue),
              foregroundColor:
              MaterialStateProperty.all(ColorManager.whiteColor)),
          child: Text(
            enableRegister ? "Register" : "Edit Course",
            style: const TextStyle(fontSize: 18),
          ),
          onPressed: () {
            if (enableRegister) {
              navigateAndPush(
                  context, RegisterScreen(course, null, null, null));
            } else {
              navigateAndPush(
                  context, EditCourseScreen(course));
            }
          }),
      appBar: AppBar(title: const Text('Course Details'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(0),elevation: 0,),
      backgroundColor: ColorManager.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: DetailsLayout(course),
      ),
    );
  }
}
