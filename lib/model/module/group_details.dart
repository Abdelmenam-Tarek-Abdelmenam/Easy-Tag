import 'package:auto_id/model/module/course.dart';

class GroupDetails {
  List<String>? studentNames;
  Course course;
  int get itemsLength => studentNames?.length ?? 0;

  GroupDetails({this.studentNames, required this.course});
}
