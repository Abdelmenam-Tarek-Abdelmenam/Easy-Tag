part of "student_exam_bloc.dart";

enum StudentExamStatus { initial, loading, loaded, error }

class StudentExamStates extends Equatable {
  final StudentExamStatus status;
  final List<Question> questions;
  final int activeIndex;

  const StudentExamStates(
      {required this.status,
      required this.questions,
      required this.activeIndex});

  @override
  List<Object?> get props => [status, activeIndex, questions.length];
}

class GetInitialExamState extends StudentExamStates {
  const GetInitialExamState(
      {required StudentExamStatus status,
      required List<Question> questions,
      required int activeIndex})
      : super(status: status, questions: questions, activeIndex: activeIndex);

  factory GetInitialExamState.initial() {
    return const GetInitialExamState(
        status: StudentExamStatus.initial, questions: [], activeIndex: 0);
  }
}
