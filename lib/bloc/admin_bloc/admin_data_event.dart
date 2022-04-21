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

class CreateGroupEvent extends AdminDataEvent {
  final Course groupData;
  final List<String> instructorsMails;
  final List<String> titles;

  const CreateGroupEvent(this.groupData, this.instructorsMails, this.titles);

  @override
  List<Object?> get props => [groupData.name];
}

class SendConfigurationEvent extends AdminDataEvent {
  final String name;
  final String pass;

  const SendConfigurationEvent(this.name, this.pass);

  @override
  List<Object?> get props => [name, pass];
}

class SignOutEvent extends AdminDataEvent {
  @override
  List<Object?> get props => [true];
}
