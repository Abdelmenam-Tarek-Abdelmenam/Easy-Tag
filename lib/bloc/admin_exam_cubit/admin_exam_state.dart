part of "admin_exam_bloc.dart";

enum AdminExamStatus {
  loadingImage,
  idle,
  error,
  changeUi,
  quizLoading,
  uploadingQuiz,
  uploadedQuiz,
  addQuestion,
  uploaded
}

class AdminExamStates {
  final AdminExamStatus status;
  final int activePage;
  final List<int> scores;
  final Quiz quiz;
  final String id;

  const AdminExamStates({
    required this.activePage,
    required this.scores,
    required this.status,
    required this.id,
    required this.quiz,
  });

  factory AdminExamStates.initial(String id) {
    return AdminExamStates(
        scores: [],
        status: AdminExamStatus.idle,
        id: id,
        quiz: Quiz.empty(),
        activePage: -1);
  }

  AdminExamStates copyWith({
    int? activePage,
    AdminExamStatus? status,
    String? id,
    Quiz? quiz,
    List<int>? scores,
  }) {
    return AdminExamStates(
        scores: scores ?? this.scores,
        activePage: activePage ?? this.activePage,
        status: status ?? AdminExamStatus.changeUi,
        id: id ?? this.id,
        quiz: quiz ?? this.quiz);
  }
}
