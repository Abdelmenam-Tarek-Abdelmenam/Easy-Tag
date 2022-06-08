import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';

import '../../model/module/exam_question.dart';
import '../../model/repository/files_handling.dart';
import '../../model/repository/fire_store.dart';

part 'admin_exam_state.dart';

class AdminExamBloc extends Cubit<AdminExamStates> {
  AdminExamBloc(String id) : super(AdminExamStates.initial(id));

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  void addQuizToFireStore() async {
    if (state.status == AdminExamStatus.uploadingQuiz) return;
    if (state.quiz.checkWrongQuiz) {
      showToast("Please check your quiz");
      return;
    }
    emit(state.copyWith(status: AdminExamStatus.uploadingQuiz));
    try {
      await _fireStoreRepository.setAllQuestions(state.id, state.quiz);
      showToast("Quiz Uploaded successfully", type: ToastType.success);
      emit(state.copyWith(status: AdminExamStatus.uploadedQuiz));
    } catch (e) {
      emit(state.copyWith(status: AdminExamStatus.error));
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

  Future<void> getCourseQuestion(String id) async {
    emit(state.copyWith(status: AdminExamStatus.quizLoading, id: id));
    try {
      AdminQuiz quiz = await _fireStoreRepository.getAllQuestions(id);
      emit(state.copyWith(
          status: AdminExamStatus.idle, quiz: quiz.quiz, scores: quiz.scores));
    } catch (err) {
      showToast("sorry,An error happened");
      emit(state.copyWith(status: AdminExamStatus.error));
    }
  }

  Future<void> getQuestionFromFile() async {
    emit(state.copyWith(status: AdminExamStatus.quizLoading));
    try {
      Quiz? quiz = await DbFileHandling().importQuiz();
      emit(state.copyWith(status: AdminExamStatus.idle, quiz: quiz));
    } catch (err, stack) {
      showToast("sorry,An error happened");
      print(err);
      print(stack);
      emit(state.copyWith(status: AdminExamStatus.idle));
    }
  }

  Future<void> saveQuiz() async {
    try {
      await DbFileHandling().exportQuiz(state.quiz);
      showToast("File Export successfully at EME Quizzes",
          type: ToastType.success);
    } catch (err) {
      showToast("sorry,An error happened");
    }
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
