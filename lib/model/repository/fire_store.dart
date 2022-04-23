import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FireStoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _id => StudentDataBloc.student.id;
  String get _now => DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future<void> addCourse(String courseId) async {
    await _firestore
        .collection("students")
        .doc(_id)
        .collection("courses")
        .doc(courseId)
        .set({"Date": _now});
  }

  Future<void> setUserData(Map<String, dynamic> data) async {
    await _firestore.collection("students").doc(_id).set(data);
  }

  Future<Map<String, dynamic>> getUserData(Map<String, dynamic> data) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await _firestore.collection("students").doc(_id).get();
    return data.data() ?? {};
  }

  Future<List<String>> readAllCourses() async {
    QuerySnapshot<Map<String, dynamic>> data = await _firestore
        .collection("students")
        .doc(_id)
        .collection("courses")
        .get();
    return data.docs.map((e) => e.id).toList();
  }
}
