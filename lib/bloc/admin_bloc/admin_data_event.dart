part of "admin_data_bloc.dart";

abstract class AdminDataEvent extends Equatable {
  const AdminDataEvent();

  @override
  List<Object?> get props => [];
}

class StartAdminOperations extends AdminDataEvent {
  final AppAdmin currentUser;

  const StartAdminOperations(this.currentUser);
}

class CardDataChangedEvents extends AdminDataEvent {
  final String key;
  final String value;

  const CardDataChangedEvents(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

class LoadGroupDataEvent extends AdminDataEvent {
  final int groupIndex;
  final bool force;

  const LoadGroupDataEvent(this.groupIndex, this.force);

  @override
  List<Object?> get props => [groupIndex, force];
}

class DeleteGroupIndex extends AdminDataEvent {
  final int groupIndex;

  const DeleteGroupIndex(this.groupIndex);

  @override
  List<Object?> get props => [groupIndex];
}

class DeleteStudentIndex extends AdminDataEvent {
  final int groupIndex;
  final int userIndex;

  const DeleteStudentIndex(this.groupIndex, this.userIndex);

  @override
  List<Object?> get props => [groupIndex, userIndex];
}

class EditStudentEvent extends AdminDataEvent {
  final Map<String, dynamic> data;
  final int groupIndex;
  final int studentIndex;

  const EditStudentEvent(this.data, this.groupIndex, this.studentIndex);

  @override
  List<Object?> get props => [data, groupIndex, studentIndex];
}

class CreateGroupEvent extends AdminDataEvent {
  final Map<String, dynamic> groupData;

  const CreateGroupEvent(this.groupData);

  @override
  List<Object?> get props => [groupData];
}

class EditGroupEvent extends AdminDataEvent {
  final Map<String, dynamic> groupData;
  final String id;

  const EditGroupEvent(this.groupData, this.id);

  @override
  List<Object?> get props => [groupData, id];
}

class SendConfigurationEvent extends AdminDataEvent {
  final String name;
  final String pass;

  const SendConfigurationEvent(this.name, this.pass);

  @override
  List<Object?> get props => [name, pass];
}

class SearchByNameEvent extends AdminDataEvent {
  final String subName;
  const SearchByNameEvent(this.subName);

  @override
  List<Object?> get props => [subName];
}

class SignOutEvent extends AdminDataEvent {
  @override
  List<Object?> get props => [true];
}
