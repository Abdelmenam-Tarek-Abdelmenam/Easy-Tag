// ignore_for_file: must_be_immutable

part of "admin_data_bloc.dart";

enum AdminDataStatus { initial, loading, loaded, error }

class AdminDataStates extends Equatable {
  late AdminDataStatus status;
  late CardStudent cardStudent;
  late List<GroupDetails> groupList;

  AdminDataStates(
      {this.status = AdminDataStatus.initial,
      required this.cardStudent,
      required this.groupList});

  @override
  List<Object?> get props => [status];
}

class GetInitialDataState extends AdminDataStates {
  GetInitialDataState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory GetInitialDataState.initial() {
    return GetInitialDataState(
        status: AdminDataStatus.initial, cardStudent: CardStudent.empty);
  }

  // GetInitialDataState copyWith(
  //     {AdminDataStatus? status,
  //     CardStudent? cardStudent,
  //     List<GroupDetails>? groupList}) {
  //   return GetInitialDataState(
  //     status: status ?? this.status,
  //     cardStudent: cardStudent ?? this.cardStudent,
  //     groupList: groupList ?? this.groupList,
  //   );
  // }

  @override
  List<Object?> get props => [status, cardStudent, groupList.length];
}

class CreateGroupState extends AdminDataStates {
  CreateGroupState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory CreateGroupState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return CreateGroupState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.groupList,
        status: status);
  }

  @override
  List<Object?> get props => [status, cardStudent, groupList.length];
}

class LoadGroupDataState extends AdminDataStates {
  int groupIndex;
  bool loadingDelete;
  bool force;
  LoadGroupDataState(
      {required this.groupIndex,
      this.loadingDelete = false,
      this.force = false,
      AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory LoadGroupDataState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status, int index,
      {bool loadingSate = false, bool force = false}) {
    return LoadGroupDataState(
        groupIndex: index,
        loadingDelete: loadingSate,
        force: force,
        cardStudent: oldState.cardStudent,
        groupList: oldState.groupList,
        status: status);
  }

  @override
  List<Object?> get props =>
      [status, cardStudent, groupList.length, loadingDelete, false];
}

class DeleteUserState extends AdminDataStates {
  DeleteUserState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory DeleteUserState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status,
      {bool loadingSate = false, bool force = false}) {
    return DeleteUserState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.groupList,
        status: status);
  }
}

class EditUserState extends AdminDataStates {
  EditUserState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory EditUserState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return EditUserState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.groupList,
        status: status);
  }
}

class SignOutState extends AdminDataStates {
  SignOutState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory SignOutState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return SignOutState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.groupList,
        status: status);
  }

  @override
  List<Object?> get props => [status, cardStudent, groupList.length];
}

class SendEspDataState extends AdminDataStates {
  SendEspDataState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            groupList: groupList);

  factory SendEspDataState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return SendEspDataState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.groupList,
        status: status);
  }

  @override
  List<Object?> get props => [status, cardStudent, groupList.length];
}
