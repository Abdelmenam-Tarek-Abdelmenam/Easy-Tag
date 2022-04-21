import 'card_student.dart';

enum Gender {
  male,
  female,
}

class Student {
  late String id;
  late String name;
  String? college;
  String? department;
  String? image;
  String? cV;
  String? email;
  String? linkedIn;
  String? facebook;
  String? address;
  String? phone;
  String? phone2;
  Gender? gender;
  int? age;

  Student.fromJson(Map<String, dynamic> data) {
    id = data['ID'];
    name = data['Name'];
    age = data['Age'];
    college = data['College'];
    department = data['Department'];
    image = _cvtImgLink(data['Image']);
    cV = data['CV'];
    phone = data['Phone']?.toString();
    phone2 = data['second-Phone']?.toString();
    email = data['Email'];
    linkedIn = data['LinkedIn'];
    facebook = data['Facebook'];
    address = data['Address'];
    gender = {
      "male": Gender.male,
      "female": Gender.female,
      "null": null
    }[data['Gender'] ?? "null"];
  }

  String _cvtImgLink(String? old) {
    if (old == null) {
      old = randomPhoto;
    } else if (old.contains("drive.google.com")) {
      return "https://drive.google.com/uc?export=view&id=" + old.split('/')[5];
    } else if (!old.contains("http")) {
      old = randomPhoto;
    }
    return old;
  }
}
