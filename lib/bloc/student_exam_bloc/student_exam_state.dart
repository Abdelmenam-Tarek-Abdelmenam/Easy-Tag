part of "student_exam_bloc.dart";

enum StudentExamStatus {
  idle,
  quizLoading,
  loadingUpload,
  noExam,
  error,
  getBefore
}

class StudentExamStates extends Equatable {
  final StudentExamStatus status;
  final Quiz quiz;
  final String id;
  final int? score;

  const StudentExamStates(
      {required this.status, required this.quiz, required this.id, this.score});

  factory StudentExamStates.initial() {
    return StudentExamStates(
        status: StudentExamStatus.idle, quiz: Quiz.empty(), id: "");
  }

  StudentExamStates copyWith(
      {StudentExamStatus? status, Quiz? quiz, String? id, int? score}) {
    return StudentExamStates(
        status: status ?? this.status,
        quiz: quiz ?? this.quiz,
        score: score,
        id: id ?? this.id);
  }

  @override
  List<Object?> get props => [status, quiz.questions.length, id];
}
