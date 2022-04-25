// ignore_for_file: must_be_immutable

part of "admin_data_bloc.dart";

enum AdminDataStatus { initial, loading, loaded, error }

class AdminDataStates extends Equatable {
  late AdminDataStatus status;
  late CardStudent cardStudent;
  late List<GroupDetails> allGroupList;
  late List<String> usingIds;

  List<GroupDetails> get groupList =>
      allGroupList.where((element) => usingIds.contains(element.id)).toList();

  int getGroupIndex(String id) =>
      allGroupList.indexWhere((element) => element.id == id);

  void removeId(String id) {
    usingIds.removeWhere((element) => element == id);
    allGroupList.removeWhere((element) => element.id == id);
  }

  AdminDataStates(
      {this.status = AdminDataStatus.initial,
      required this.cardStudent,
      required this.usingIds,
      required this.allGroupList});

  @override
  List<Object?> get props => [status, cardStudent, usingIds.length];
}

class GetInitialDataState extends AdminDataStates {
  GetInitialDataState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const [],
      List<String> groupIds = const []})
      : super(
            status: status,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList,
            usingIds: groupIds);

  factory GetInitialDataState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return GetInitialDataState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        groupIds: oldState.usingIds,
        status: status);
  }

  factory GetInitialDataState.initial() {
    return GetInitialDataState(
        status: AdminDataStatus.initial, cardStudent: CardStudent.empty);
  }
}

class CreateGroupState extends AdminDataStates {
  CreateGroupState(
      {AdminDataStatus status = AdminDataStatus.initial,
      CardStudent? cardStudent,
      List<GroupDetails> groupList = const [],
      List<String> groupIds = const []})
      : super(
            status: status,
            usingIds: groupIds,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList);

  factory CreateGroupState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return CreateGroupState(
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        groupIds: oldState.usingIds,
        status: status);
  }
}

class LoadGroupDataState extends AdminDataStates {
  int groupIndex;
  bool loadingDelete;
  bool force;
  LoadGroupDataState({
    required this.groupIndex,
    this.loadingDelete = false,
    this.force = false,
    AdminDataStatus status = AdminDataStatus.initial,
    CardStudent? cardStudent,
    List<GroupDetails> groupList = const [],
    List<String> groupIds = const [],
  }) : super(
            status: status,
            usingIds: groupIds,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList);

  factory LoadGroupDataState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status, int index,
      {bool loadingSate = false, bool force = false}) {
    return LoadGroupDataState(
        groupIndex: index,
        groupIds: oldState.usingIds,
        loadingDelete: loadingSate,
        force: force,
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        status: status);
  }

  @override
  List<Object?> get props =>
      [status, cardStudent, usingIds.length, loadingDelete, groupIndex, force];
}

class DeleteUserState extends AdminDataStates {
  DeleteUserState({
    AdminDataStatus status = AdminDataStatus.initial,
    CardStudent? cardStudent,
    List<GroupDetails> groupList = const [],
    List<String> groupIds = const [],
  }) : super(
            status: status,
            usingIds: groupIds,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList);

  factory DeleteUserState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status,
      {bool loadingSate = false, bool force = false}) {
    return DeleteUserState(
        groupIds: oldState.usingIds,
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        status: status);
  }
}

class EditUserState extends AdminDataStates {
  EditUserState({
    AdminDataStatus status = AdminDataStatus.initial,
    CardStudent? cardStudent,
    List<GroupDetails> groupList = const [],
    List<String> groupIds = const [],
  }) : super(
            status: status,
            usingIds: groupIds,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList);

  factory EditUserState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return EditUserState(
        groupIds: oldState.usingIds,
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        status: status);
  }
}

class SignOutState extends AdminDataStates {
  SignOutState({
    AdminDataStatus status = AdminDataStatus.initial,
    CardStudent? cardStudent,
    List<GroupDetails> groupList = const [],
    List<String> groupIds = const [],
  }) : super(
            status: status,
            usingIds: groupIds,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList);

  factory SignOutState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return SignOutState(
        groupIds: oldState.usingIds,
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        status: status);
  }
}

class SendEspDataState extends AdminDataStates {
  SendEspDataState({
    AdminDataStatus status = AdminDataStatus.initial,
    CardStudent? cardStudent,
    List<GroupDetails> groupList = const [],
    List<String> groupIds = const [],
  }) : super(
            status: status,
            usingIds: groupIds,
            cardStudent: cardStudent ?? CardStudent.empty,
            allGroupList: groupList);

  factory SendEspDataState.fromOldState(
      AdminDataStates oldState, AdminDataStatus status) {
    return SendEspDataState(
        groupIds: oldState.usingIds,
        cardStudent: oldState.cardStudent,
        groupList: oldState.allGroupList,
        status: status);
  }
}
