import 'dart:async';

import 'package:auto_id/model/module/group_details.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../bloc/admin_bloc/admin_data_bloc.dart';
import '../module/card_student.dart';

class AdminDataRepository {
  final DatabaseReference _dataBase = FirebaseDatabase.instance.ref();
  StreamSubscription? _listener;

  Future<CardStudent> readAdminData() async {
    DataSnapshot snap =
        await _dataBase.child(AdminDataBloc.admin.id).child("lastCard").get();
    if (snap.exists) {
      return CardStudent.fromFireBase(snap.value);
    } else {
      return CardStudent();
    }
  }

  Future<List<GroupDetails>> getGroupNames() async {
    DataSnapshot snap =
        await _dataBase.child(AdminDataBloc.admin.id).child("groups").get();
    if (snap.exists) {
      return snap.children
          .map((e) =>
              GroupDetails(name: e.key.toString(), id: e.value.toString()))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> deleteGroup(String groupName) async {
    await _dataBase
        .child(AdminDataBloc.admin.id)
        .child("groups")
        .child(groupName)
        .remove();
  }

  Future<void> updateCardState() async {
    await _dataBase
        .child(AdminDataBloc.admin.id)
        .child("lastCard")
        .update({"state": "problem"});
  }

  Future<void> createGroup(GroupDetails group) async {
    await _dataBase
        .child(AdminDataBloc.admin.id)
        .child("groups")
        .update({group.name: group.id});
  }

  Future<void> buildListener(Function(String key, dynamic value) onData) async {
    await cancelListener();
    _listener = _dataBase
        .child(AdminDataBloc.admin.id)
        .child("lastCard")
        .onChildChanged
        .listen((event) {
      onData(event.snapshot.key!, event.snapshot.value);
    });
  }

  Future<void> cancelListener() async {
    if (_listener != null) await _listener?.cancel();
  }
}
