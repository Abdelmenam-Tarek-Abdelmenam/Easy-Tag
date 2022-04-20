import 'package:auto_id/model/module/course.dart';
import 'package:flutter/material.dart';

class DetailsLayout extends StatelessWidget {
  final Course course;
  const DetailsLayout(this.course, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}
