part of "student_data_bloc.dart";

abstract class StudentDataEvent extends Equatable {
  const StudentDataEvent();

  @override
  List<Object?> get props => [];
}

class StartStudentOperations extends StudentDataEvent {
  final AppAdmin user;
  const StartStudentOperations(this.user);
}
