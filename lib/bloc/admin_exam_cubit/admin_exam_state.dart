part of "admin_exam_bloc.dart";

enum AdminExamStatus {
  loadingImage,
  idle,
  error,
  changeUi,
  uploadingQuiz,
  addQuestion,
  uploaded
}

class AdminExamStates {
  final AdminExamStatus status;
  final int activePage;
  final Quiz quiz;
  final String id;

  const AdminExamStates({
    required this.activePage,
    required this.status,
    required this.id,
    required this.quiz,
  });

  factory AdminExamStates.initial(String id) {
    return AdminExamStates(
        status: AdminExamStatus.idle, id: id, quiz: testQuiz, activePage: -1);
  }

  AdminExamStates copyWith({
    int? activePage,
    AdminExamStatus? status,
    String? id,
    Quiz? quiz,
  }) {
    return AdminExamStates(
        activePage: activePage ?? this.activePage,
        status: status ?? AdminExamStatus.changeUi,
        id: id ?? this.id,
        quiz: quiz ?? this.quiz);
  }
}
