part of "admin_exam_bloc.dart";

abstract class AdminExamEvent extends Equatable {
  const AdminExamEvent();

  @override
  List<Object?> get props => [];
}

class UploadQuizEvent extends AdminExamEvent {
  const UploadQuizEvent();

  @override
  List<Object?> get props => [0];
}
