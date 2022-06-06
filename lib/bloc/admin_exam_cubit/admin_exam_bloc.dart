import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';

import '../../model/module/exam_question.dart';
import '../../model/repository/fire_store.dart';

part 'admin_exam_state.dart';

class AdminExamBloc extends Cubit<AdminExamStates> {
  AdminExamBloc(String id) : super(AdminExamStates.initial(id));

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  void addQuizToFireStore() async {
    try {
      print(state.quiz.toJson);
      // await _fireStoreRepository.setAllQuestions(state.id, state.quiz);
    } catch (e) {
      print(e);
    }
  }

  void changePage(int newPage) {
    emit(state.copyWith(activePage: newPage - 1));
  }

  void changeAnswerState(int index, bool value) {
    state.quiz.questions[state.activePage].rightAnswer[index] = (value);
    emit(state.copyWith());
  }

  void changeQuestionImage(String img, int index) {
    state.quiz.questions[index].img = img;
    emit(state.copyWith());
  }

  void changeQuestionState() {
    emit(state.copyWith(status: AdminExamStatus.loadingImage));
  }

  void getCourseQuestion(String id) {
    _fireStoreRepository.getAllQuestions(id);
  }

  void removeQuestion() {
    if (state.activePage == -1) {
      showToast("No active question selected");
      return;
    }
    state.quiz.questions.removeAt(state.activePage);
    emit(state.copyWith());
  }

  void addQuestion() {
    state.quiz.questions.add(Question.empty());
    emit(state.copyWith(status: AdminExamStatus.addQuestion));
  }

  void removeImageQuestion() {
    state.quiz.questions[state.activePage].img = null;
    emit(state.copyWith());
  }

  void removeLastAnswer() {
    state.quiz.questions[state.activePage].removeLastAnswer();
    emit(state.copyWith());
  }

  void addAnswer() {
    state.quiz.questions[state.activePage].addEmptyAnswer();
    emit(state.copyWith());
  }
}

extension AddQuestion on Question {
  void addEmptyAnswer() {
    if (answers.length < 10) {
      rightAnswer.add(false);
      answers.add('');
    }
  }

  void removeLastAnswer() {
    if (answers.length > 2) {
      rightAnswer.removeLast();
      answers.removeLast();
    }
  }
}
