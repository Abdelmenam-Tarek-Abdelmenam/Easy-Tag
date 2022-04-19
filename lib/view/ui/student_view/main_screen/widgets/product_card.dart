// ignore: must_be_immutable
import 'package:auto_id/model/module/course.dart';
import 'package:flutter/material.dart';

class CourseCardDesign extends StatelessWidget {
  final Course course;
  final int index;

  const CourseCardDesign({
    Key? key,
    required this.course,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigateAndPush(context, DetailsScreen(course, index));
      },
      child: Container(),
    );
  }
}
