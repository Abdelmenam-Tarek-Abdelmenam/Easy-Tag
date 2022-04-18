class GroupDetails {
  String name;
  String id;
  List<String>? studentNames;
  List<String>? columnNames;
  int get itemsLength => columnNames?.length ?? 0;

  GroupDetails(
      {required this.name,
      required this.id,
      this.studentNames,
      this.columnNames});
}
