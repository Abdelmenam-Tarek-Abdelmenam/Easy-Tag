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

  Student.fromJson(Map<String, dynamic> data) {
    id = data['ID'];
    rfId = data['RFID'].toString();
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
