part of "admin_exam_bloc.dart";

enum AdminExamStatus { initial, loading, loaded, error }

class AdminExamStates extends Equatable {
  final AdminExamStatus status;
  final Quiz quiz;
  final String id;

  const AdminExamStates({
    required this.status,
    required this.id,
    required this.quiz,
  });

  @override
  List<Object?> get props => [status, quiz.questions.length];
}

class GetInitialExamState extends AdminExamStates {
  const GetInitialExamState(
      {required AdminExamStatus status,
      required Quiz quiz,
      required String id,
      required int activeIndex})
      : super(status: status, quiz: quiz, id: id);

  factory GetInitialExamState.initial() {
    return GetInitialExamState(
        status: AdminExamStatus.initial,
        id: '',
        quiz: Quiz.empty(),
        activeIndex: 0);
  }
}
