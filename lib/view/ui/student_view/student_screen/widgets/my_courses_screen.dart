import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisteredScreen extends StatelessWidget {
  const RegisteredScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> ids = context.read<StudentDataBloc>().state.registeredId;
    List<Course> courses = context
        .read<StudentDataBloc>()
        .state
        .allCourses
        .where((element) => ids.contains(element.id))
        .toList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.lightBlue,
        primary: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
              ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    CourseCardDesign(courses[index]),
                itemCount: courses.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
