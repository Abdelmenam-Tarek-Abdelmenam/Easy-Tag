import 'dart:convert';

import 'package:equatable/equatable.dart';

const String randomPhoto =
    "https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805__340.png";

// ignore: must_be_immutable
class CardStudent extends Equatable {
  String? name;
  String? id;
  late String imgUrl;
  StudentState state = StudentState.empty;
  int? groupIndex;

  CardStudent(
      {this.name,
      this.id,
      this.state = StudentState.empty,
      this.imgUrl = randomPhoto,
      this.groupIndex});

  static CardStudent empty = CardStudent(state: StudentState.empty);

  CardStudent.fromFireBase(dynamic rowData) {
    name = rowData['name'].toString();
    id = rowData['lastID'].toString();
    state = _mapState(rowData['state'].toString());
    imgUrl = _cvtImgLink(_decodedField(rowData['imgUrl'].toString())) ?? "";
    groupIndex = rowData['groupIndex'];
  }

  CardStudent edit(String key, dynamic value) {
    print(key);
    print(value);
    switch (key) {
      case "groupIndex":
        return copyWith(groupIndex: value);
      case "imgUrl":
        return copyWith(
            imgUrl: _cvtImgLink(_decodedField(value.toString()) ?? ""));
      case "state":
        return copyWith(state: _mapState(value.toString()));
      case "name":
        return copyWith(name: value);
      case "lastID":
        return copyWith(id: value.toString());
      default:
        return this;
    }
  }

  CardStudent copyWith(
      {String? name,
      String? id,
      StudentState? state,
      String? imgUrl,
      int? groupIndex}) {
    return CardStudent(
      name: name ?? this.name,
      id: id ?? this.id,
      state: state ?? this.state,
      imgUrl: imgUrl ?? this.imgUrl,
      groupIndex: groupIndex ?? this.groupIndex,
    );
  }

  StudentState _mapState(String text) {
    return {
      "Done": StudentState.registered,
      "problem": StudentState.notRegistered,
      "Not Found": StudentState.newStudent,
      "NULL": StudentState.empty
    }[text]!;
  }

  String? _cvtImgLink(String? old) {
    if ((old ?? '').contains("=view&id=")) {
      return old;
    } else if ((old ?? "").contains("drive.google.com")) {
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

  String? _decodedField(String? old) {
    if (old == null) return old;
    try {
      final decodeBase64Json = base64.decode(old.trim());
      return utf8.decode(decodeBase64Json);
    } catch (err) {
      return "Wrong formatted";
    }
  }

  @override
  List<Object?> get props => [name, state, id, imgUrl, groupIndex];
}

enum StudentState { registered, notRegistered, newStudent, empty }
