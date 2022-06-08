import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../module/exam_question.dart';

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

  Future<void> deleteCourse(String courseId, String userId) async {
    await _firestore
        .collection("students")
        .doc(userId)
        .collection("courses")
        .doc(courseId)
        .delete();
  }

  Future<List<String>> readAllCourses() async {
    QuerySnapshot<Map<String, dynamic>> data = await _firestore
        .collection("students")
        .doc(_id)
        .collection("courses")
        .get();
    return data.docs.map((e) => e.id).toList();
  }

  Future<AdminQuiz> getAllQuestions(String courseId) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection("Exams").doc(courseId).get();
    return AdminQuiz.fromJson(snap.data());
  }

  Future<StudentQuiz> getExamForStudent(String courseId) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection("Exams").doc(courseId).get();
    bool takesBefore = snap.data()?.keys.contains(_id) ?? false;
    return StudentQuiz(
        Quiz.fromJson(snap.data()), takesBefore, (snap.data() ?? {})[_id]);
  }

  Future<void> setAllQuestions(String courseId, Quiz quiz) async {
    await _firestore.collection("Exams").doc(courseId).set(quiz.toJson);
  }

  Future<void> setExamSolved(String courseId, int grade) async {
    await _firestore.collection("Exams").doc(courseId).update({_id: grade});
  }

  Future<void> setUserData(Map<String, dynamic> data) async {
    await _firestore.collection("students").doc(_id).set(data);
  }

  Future<Map<String, dynamic>> getUserData(Map<String, dynamic> data) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await _firestore.collection("students").doc(_id).get();
    return data.data() ?? {};
  }
}
