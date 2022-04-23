part of "student_data_bloc.dart";

abstract class StudentDataEvent extends Equatable {
  const StudentDataEvent();

  @override
  List<Object?> get props => [];
}

class RegisterStudentEvent extends StudentDataEvent {
  final Map<String, dynamic> data;
  final String groupId;

  const RegisterStudentEvent(this.data, this.groupId);

  @override
  List<Object?> get props => [data['ID'], groupId];
}

class StartStudentOperations extends StudentDataEvent {
  final AppAdmin user;
  const StartStudentOperations(this.user);
}
