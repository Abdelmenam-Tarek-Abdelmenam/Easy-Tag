import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/model/module/exam_question.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/repository/fire_store.dart';
import '../../model/repository/web_sevices.dart';

part 'student_exam_state.dart';

class StudentExamBloc extends Cubit<StudentExamStates> {
  StudentExamBloc() : super(StudentExamStates.initial());

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  getCourseQuestion(String id) async {
    emit(state.copyWith(status: StudentExamStatus.quizLoading, id: id));
    try {
      StudentQuiz quiz = await _fireStoreRepository.getExamForStudent(id);
      if (quiz.quiz.questions.isEmpty) {
        emit(state.copyWith(status: StudentExamStatus.noExam));
      } else if (quiz.takenBefore) {
        emit(state.copyWith(
            status: StudentExamStatus.getBefore, score: quiz.score));
      } else {
        emit(state.copyWith(status: StudentExamStatus.idle, quiz: quiz.quiz));
      }
    } catch (err, stack) {
      print(stack);
      print(err);
      showToast("sorry,An error happened");
      emit(state.copyWith(status: StudentExamStatus.error));
    }
  }

  publishResults(int score, {int? duration}) async {
    emit(state.copyWith(status: StudentExamStatus.loadingUpload));
    try {
      await _fireStoreRepository.setExamSolved(state.id, score);
      if (duration != null) {
        await WebServices().saveUserScore(
            userId: StudentDataBloc.student.id,
            sheetId: state.id,
            quizId: state.quiz.title + "/-/" + state.quiz.getRandomText,
            score: score,
            time: duration,
            len: state.quiz.length);
      }
      emit(state.copyWith(status: StudentExamStatus.loadedUpload));
    } catch (err) {
      showToast("sorry,An error happened");
      emit(state.copyWith(status: StudentExamStatus.error));
    }
  }
}
