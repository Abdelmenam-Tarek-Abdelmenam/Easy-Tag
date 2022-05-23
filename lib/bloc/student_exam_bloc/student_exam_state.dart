part of "student_exam_bloc.dart";

enum StudentExamStatus { initial, loading, loaded, error }

class StudentExamStates extends Equatable {
  final StudentExamStatus status;

  const StudentExamStates({
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}

class GetInitialExamState extends StudentExamStates {
  const GetInitialExamState({
    StudentExamStatus status = StudentExamStatus.initial,
  }) : super(status: status);

  factory GetInitialExamState.initial() {
    return const GetInitialExamState();
  }
}
