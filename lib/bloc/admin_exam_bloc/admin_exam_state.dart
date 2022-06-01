part of "admin_exam_bloc.dart";

enum AdminExamStatus { initial, loading, loaded, error }

class AdminExamStates extends Equatable {
  final AdminExamStatus status;
  final List<Question2> questions;

  const AdminExamStates({
    required this.status,
    required this.questions,
  });

  @override
  List<Object?> get props => [status, questions.length];
}

class GetInitialExamState extends AdminExamStates {
  const GetInitialExamState(
      {required AdminExamStatus status,
      required List<Question2> questions,
      required int activeIndex})
      : super(status: status, questions: questions);

  factory GetInitialExamState.initial() {
    return const GetInitialExamState(
        status: AdminExamStatus.initial, questions: [], activeIndex: 0);
  }
}
