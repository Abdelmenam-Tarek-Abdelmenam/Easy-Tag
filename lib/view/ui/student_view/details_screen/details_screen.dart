import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/student_view/details_screen/widgets/details_layout.dart';
import 'package:auto_id/view/ui/student_view/register_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/module/course.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../admin_view/edit_course/edit_course_screen.dart';
import '../../admin_view/user_screen/user_screen.dart';

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
    bool myCourse = false;
    if (enableRegister) {
      myCourse = context
          .read<StudentDataBloc>()
          .state
          .registeredId
          .contains(course.id);
    }
    return Scaffold(
      bottomNavigationBar: enableRegister
          ? BlocConsumer<StudentDataBloc, StudentDataStates>(
              listenWhen: (_, state) => state is GetStudentDataState,
              buildWhen: (_, state) => state is GetStudentDataState,
              listener: (context, state) {
                if (state is GetStudentDataState &&
                    (state.status == StudentDataStatus.loaded)) {
                  navigateAndPush(
                      context,
                      UserScreen(
                          student: state.student!,
                          userIndex: -1,
                          groupIndex: -1));
                }
              },
              builder: (_, state) =>
                  button(myCourse ? "Show my data" : "Register", () {
                if (myCourse) {
                  context
                      .read<StudentDataBloc>()
                      .add(WantUserDataEvent(course.id));
                } else {
                  navigateAndPush(
                      context, RegisterScreen(course, null, null, null));
                }
              }, loading: state.status == StudentDataStatus.loading),
            )
          : button("Edit Course",
              () => navigateAndPush(context, EditCourseScreen(course))),
      appBar: appBar('Course Details'),
      backgroundColor: ColorManager.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: DetailsLayout(course),
      ),
    );
  }
  //  enableRegister
  //             ? myCourse
  //             ? "Show my data"
  //             : "Register"
  //             :

  // if (enableRegister) {
  //           if (myCourse) {
  //             context
  //                 .read<StudentDataBloc>()
  //                 .add(WantUserDataEvent(course.id));
  //           } else {
  //             navigateAndPush(
  //                 context, RegisterScreen(course, null, null, null));
  //           }
  //         } else {
  //           navigateAndPush(context, EditCourseScreen(course));
  //         }
  Widget button(String text, Function() onPressed, {bool loading = false}) =>
      ElevatedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(40, 50)),
              backgroundColor: MaterialStateProperty.all(ColorManager.mainBlue),
              foregroundColor:
                  MaterialStateProperty.all(ColorManager.whiteColor)),
          child: loading
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
          onPressed: onPressed);
}
