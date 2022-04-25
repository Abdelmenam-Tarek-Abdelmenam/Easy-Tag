import 'dart:async';

import 'package:auto_id/model/module/group_details.dart';
import 'package:firebase_database/firebase_database.dart';

import '../module/card_student.dart';

const _id = "jCekYTPEXmMD7XJWlJdPPtrLBED2";

class AdminDataRepository {
  final DatabaseReference _dataBase = FirebaseDatabase.instance.ref();
  StreamSubscription? _listener;

  Future<CardStudent> readAdminData() async {
    DataSnapshot snap = await _dataBase.child(_id).child("lastCard").get();
    if (snap.exists) {
      return CardStudent.fromFireBase(snap.value);
    } else {
      return CardStudent();
    }
  }

  Future<List<GroupDetails>> getGroupsData() async {
    DataSnapshot snap = await _dataBase.child(_id).child("groups").get();
    if (snap.exists) {
      print("data geted");
      print(snap.children.first.value);
      print(snap.children.first.value.runtimeType);
      print(snap.children.first.key);
      // return [];
      return snap.children
          .map((e) => GroupDetails(json: e.value, id: e.key.toString()))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> deleteGroup(String groupId) async {
    await _dataBase.child(_id).child("groups").child(groupId).remove();
  }

  Future<void> updateCardState() async {
    await _dataBase.child(_id).child("lastCard").update({"state": "problem"});
  }

  Future<void> createGroup(GroupDetails group) async {
    await _dataBase
        .child(_id)
        .child("groups")
        .child(group.id)
        .update(group.toJson);
  }

  Future<void> editCourse(String id, Map<String, dynamic> newData) async {
    await _dataBase.child(_id).child("groups").child(id).update(newData);
  }

  Future<void> buildListener(Function(String key, dynamic value) onData) async {
    await cancelListener();
    _listener =
        _dataBase.child(_id).child("lastCard").onChildChanged.listen((event) {
      onData(event.snapshot.key!, event.snapshot.value);
    });
  }

  Future<void> cancelListener() async {
    if (_listener != null) await _listener?.cancel();
  }
}
