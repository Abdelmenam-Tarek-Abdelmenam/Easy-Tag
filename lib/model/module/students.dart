import 'dart:convert';

enum Gender {
  male,
  female,
}

class Student {
  late String id;
  String? rfId;
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
  Map<String, String> attendance = {};

  Student.fromJson(Map<String, dynamic> data) {
    print(data);
    attendance = Map<String, String>.from(data['attendance'] ?? {});
    id = data['UID'] ?? "ID";
    rfId = data['RFID']?.toString();
    name = data['Name'];
    age = data['Age'];
    college = data['College'];
    department = data['Department'];
    image = _cvtImgLink(_decodedField(data['Image']));
    cV = _decodedField(data['CV']);
    phone = data['Phone']?.toString();
    phone2 = data['second-Phone']?.toString();
    email = data['Email'];
    linkedIn = _decodedField(data['LinkedIn']);
    facebook = _decodedField(data['Facebook']);
    address = data['Address'];
    gender = {
      "Gender.male": Gender.male,
      "Gender.female": Gender.female,
      "null": null
    }[data['Gender'] ?? "null"];
    print("gender is $gender");
  }

  String? _decodedField(String? old) {
    if (old == null) return old;
    try {
      final decodeBase64Json = base64.decode(old.trim());
      return utf8.decode(decodeBase64Json);
    } catch (err) {
      return "Wrong formatted";
    }
  }

  String? _cvtImgLink(String? old) {
    if ((old ?? "").contains("drive.google.com")) {
      try {
        return "https://drive.google.com/uc?export=view&id=" +
            old!.split('/')[5];
      } catch (err) {
        return null;
      }
    } else if (!(old ?? "").contains("http")) {
      old = null;
    }
    return old;
  }

  List get getProps => [
        name,
        age,
        college,
        department,
        image,
        cV,
        phone,
        phone2,
        email,
        linkedIn,
        facebook,
        address,
        gender,
      ];
}
