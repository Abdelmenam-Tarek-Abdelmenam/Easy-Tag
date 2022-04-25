const String _onlineLogo =
    "https://firebasestorage.googleapis.com/v0/b/id-presence.appspot.com/o/logo.png?alt=media&token=2c9ee99a-19ac-4589-b581-108ddf468491";

class Course {
  late String name;
  late String id;
  int? numberOfSessions;
  late int price;
  late String description;
  late String offer;
  late List<String> instructors;
  late String logo;
  late String date;
  late String category;
  late String inPlace;
  late List<bool> columns;

  Course.fromJson(json, String cId) {
    id = cId;
    name = json['name'];
    numberOfSessions = json['numberOfSessions'];
    price = json['priceController'];
    description = json['description'];
    offer = json['offer'].toString();
    category = json['category'];
    inPlace = json['inPlace'];
    logo = json['logo'] ?? _onlineLogo;
    date = json['startDate'];
    // columns = json['columnNames'].map((e) => e.toString() == "true").toList();
    instructors = List<String>.from(json['instructorsNames']);
    columns = List<bool>.from(json['columnNames']);
  }
  void editCourse(Map<String, dynamic> json) {
    name = json['name'];
    numberOfSessions = json['numberOfSessions'];
    price = json['priceController'];
    description = json['description'];
    offer = json['offer'].toString();
    category = json['category'];
    inPlace = json['inPlace'];
    logo = json['logo'] ?? _onlineLogo;
    date = json['startDate'];
  }

  Map<String, dynamic> get toJson => {
        'columnNames': columns,
        "name": name,
        "numberOfSessions": numberOfSessions,
        "priceController": price,
        "description": description,
        "offer": offer,
        "category": category,
        "inPlace": inPlace,
        "logo": logo,
        "startDate": date,
        "instructorsNames": instructors,
      };
}
