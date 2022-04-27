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

class QrReadEvent extends StudentDataEvent {
  final String groupId;

  const QrReadEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class StartStudentOperations extends StudentDataEvent {
  final AppAdmin user;
  const StartStudentOperations(this.user);
}

class WantUserDataEvent extends StudentDataEvent {
  final String groupId;
  const WantUserDataEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class EditMyStudentEvent extends StudentDataEvent {
  final Map<String, dynamic> data;
  final String groupId;

  const EditMyStudentEvent(this.data, this.groupId);

  @override
  List<Object?> get props => [data, groupId];
}

class ChangeFilterTypeEvent extends StudentDataEvent {
  final String newType;
  const ChangeFilterTypeEvent(this.newType);

  @override
  List<Object?> get props => [newType];
}

class ChangeFilterNameEvent extends StudentDataEvent {
  final String subName;
  const ChangeFilterNameEvent(this.subName);

  @override
  List<Object?> get props => [subName];
}
