import 'package:auto_id/model/module/exam_question.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/repository/fire_store.dart';

part 'student_exam_event.dart';
part 'student_exam_state.dart';

class StudentExamBloc extends Cubit<StudentExamStates> {
  StudentExamBloc() : super(StudentExamStates.initial());

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  getCourseQuestion(String id) async {
    emit(state.copyWith(status: StudentExamStatus.quizLoading, id: id));
    try {
      Quiz quiz = await _fireStoreRepository.getAllQuestions(id);
      emit(state.copyWith(status: StudentExamStatus.idle, quiz: quiz));
    } catch (err) {
      showToast("sorry,An error happened");
      emit(state.copyWith(status: StudentExamStatus.error));
    }
  }

  publishResults(int score) async {
    emit(state.copyWith(status: StudentExamStatus.loadingUpload));
    try {
      await _fireStoreRepository.setExamSolved(state.id, score);
      emit(state.copyWith(status: StudentExamStatus.idle));
    } catch (err) {
      showToast("sorry,An error happened");
      emit(state.copyWith(status: StudentExamStatus.error));
    }
  }
}
