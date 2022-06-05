part of "student_exam_bloc.dart";

enum StudentExamStatus { initial, loading, loaded, error }

class StudentExamStates extends Equatable {
  final StudentExamStatus status;
  final Quiz quiz;
  final int activeIndex;

  const StudentExamStates(
      {required this.status, required this.quiz, required this.activeIndex});

  @override
  List<Object?> get props => [status, activeIndex, quiz.questions.length];
}

class GetInitialExamState extends StudentExamStates {
  const GetInitialExamState(
      {required StudentExamStatus status,
      required Quiz quiz,
      required int activeIndex})
      : super(status: status, quiz: quiz, activeIndex: activeIndex);

  factory GetInitialExamState.initial() {
    return GetInitialExamState(
        status: StudentExamStatus.initial, quiz: Quiz.empty(), activeIndex: 0);
  }
}
