import 'package:auto_id/model/module/exam_question.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/exam_question.dart';
import '../../model/repository/fire_store.dart';

part 'student_exam_event.dart';
part 'student_exam_state.dart';

class StudentExamBloc extends Bloc<StudentExamEvent, StudentExamStates> {
  StudentExamBloc() : super(GetInitialExamState.initial());

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  getCourseQuestion(String id) {
    _fireStoreRepository.getAllQuestions(id);
  }
}
