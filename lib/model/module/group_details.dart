import 'package:auto_id/model/module/course.dart';

class GroupDetails extends Course {
  List<Map<String, dynamic>>? students;
  int get studentLength => students?.length ?? 0;

  List<String> get getStudentsNames =>
      students?.map((e) => e['Name'].toString()).toList() ?? [];

  GroupDetails({
    this.students,
    required json,
    required String id,
  }) : super.fromJson(json, id);
}
