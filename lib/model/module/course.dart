class Course {
  late String name;
  int? maxStudent;
  int? numberOfSessions;
  late int price;
  late String description;
  late String offer;
  late List<String> instructors;
  String? logo;
  late String date;
  late String category;
  late String inPlace;
  late List<bool> columns;

  Course.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    maxStudent = json['maxStudents'];
    numberOfSessions = json['numberOfSessions'];
    price = json['priceController'];
    description = json['description'];
    offer = json['offer'];
    category = json['category'];
    inPlace = json['inPlace'];
    logo = json['logo'];
    date = json['startDate'];
    columns = json['columnNames'];
    instructors = json['instructorsNames'];
  }
}
