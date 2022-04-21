import 'dart:math';

import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/home_app_bar.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/list_view_filter_buttons.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/loading_card.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class StudentMainScreen extends StatelessWidget {
  StudentMainScreen({Key? key}) : super(key: key);

  final Random r = Random();
  late final List<Course> courses = List.generate(
      10,
      (index) => Course.fromJson({
            'columnNames': List.generate(14, (index) => r.nextBool()),
            "name": "IOT",
            "maxStudents": 10,
            "numberOfSessions": 5,
            "priceController": 100,
            "description":
                "Very important course which explain \n ESP32 programming \n MQTT protocol",
            "offer": "75 for teams",
            "category": "Course",
            "inPlace": "on line",
            "logo": null,
            "startDate": 'dd-MM-yyyy',
            "instructorsNames": ['Ahmed', 'Menam', 'Mohamed'],
            "instructorsEmails": ['Ahmed', 'Menam', 'Mohamed'],
          }));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorManager.lightBlue,
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const HomeAppBar(),
                const CategoryButtonsList(),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: BlocBuilder<StudentDataBloc, StudentDataStates>(
                      buildWhen: (prev, next) => true, // check state
                      builder: (context, state) {
                        if (state.status == StudentDataStatus.loading) {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.5),
                              highlightColor: Colors.white,
                              child: const LoadingView());
                        } else {
                          if (state.courses.isNotEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.table_rows_outlined,
                                  color: ColorManager.lightGrey,
                                  size: 70,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "No Courses",
                                  style: TextStyle(
                                      color: ColorManager.lightGrey,
                                      fontSize: 18),
                                )
                              ],
                            );
                          }
                          return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (_, index) => CourseCardDesign(
                                    courses[index],
                                  ),
                              separatorBuilder: (_, __) => const SizedBox(
                                    height: 15,
                                  ),
                              itemCount: courses.length);
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
