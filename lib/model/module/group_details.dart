import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/model/module/students.dart';

class GroupDetails extends Course {
  List<Student>? students;
  int get studentLength => students?.length ?? 0;

  List<String> get getStudentsNames =>
      students?.map((e) => e.name.toString()).toList() ?? [];

  GroupDetails({
    this.students,
    required json,
    required String id,
  }) : super.fromJson(json, id);
}
