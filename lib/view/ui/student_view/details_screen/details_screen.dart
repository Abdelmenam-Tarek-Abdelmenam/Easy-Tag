import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:auto_id/view/ui/student_view/details_screen/widgets/details_layout.dart';
import 'package:auto_id/view/ui/student_view/register_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../model/module/course.dart';
import '../../../../model/repository/auth_repository.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../admin_view/edit_course/edit_course_screen.dart';
import '../../admin_view/user_screen/user_screen.dart';
import '../../start_screen/signing/login_screen.dart';
import '../main_screen/main_screen.dart';
import '../solve_questions/exam_intro_screen.dart';

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
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          return true;
        } else {
          navigateAndReplace(context, StudentMainScreen());
          return false;
        }
      },
      child: Scaffold(
        bottomNavigationBar: enableRegister
            ? BlocConsumer<StudentDataBloc, StudentDataStates>(
                listenWhen: (_, state) => state is GetStudentDataState,
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
                builder: (_, state) {
                  if (enableRegister) {
                    myCourse = context
                        .read<StudentDataBloc>()
                        .state
                        .registeredId
                        .contains(course.id);
                  }
                  return myCourse
                      ? Container(
                          color: Colors.black.withOpacity(0.1),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                state.status == StudentDataStatus.loading
                                    ? const Expanded(
                                        child: Center(
                                            child: CircularProgressIndicator()))
                                    : Expanded(
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue)),
                                          onPressed: () {
                                            context.read<StudentDataBloc>().add(
                                                WantUserDataEvent(course.id));
                                          },
                                          label: const Text('My Data'),
                                          icon: const Icon(
                                            Icons.person,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue)),
                                    onPressed: () {
                                      navigateAndPush(
                                          context, IntroExamScreen(course.id));
                                    },
                                    label: const Text('Quiz'),
                                    icon: const Icon(
                                      Icons.question_mark,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : button(
                          "Register",
                          (course.getDate.difference(DateTime.now()).isNegative
                              ? null
                              : () async {
                                  if (course.registrationForm != null) {
                                    if (!await launchUrl(course.form)) {
                                      showToast('Could not launch');
                                    }
                                  } else {
                                    if (StudentDataBloc.student.isAnonymous) {
                                      await AuthRepository.signOut();
                                      context
                                          .read<StudentDataBloc>()
                                          .signOutHandler();
                                      navigateAndReplace(
                                          context,
                                          LoginView(
                                            course: course,
                                          ));
                                      showToast("Please login to register",
                                          type: ToastType.info);
                                    } else {
                                      navigateAndPush(
                                          context,
                                          RegisterScreen(
                                              course, null, null, null));
                                    }
                                  }
                                }),
                          loading: state.status == StudentDataStatus.loading);
                })
            : button("Edit Course",
                () => navigateAndPush(context, EditCourseScreen(course))),
        appBar: appBar('Course Details'),
        backgroundColor: ColorManager.whiteColor,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: DetailsLayout(course),
        ),
      ),
    );
  }

  Widget button(String text, Function()? onPressed, {bool loading = false}) =>
      ElevatedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(40, 50)),
              backgroundColor: MaterialStateProperty.all(onPressed == null
                  ? ColorManager.lightGrey
                  : ColorManager.mainBlue),
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
