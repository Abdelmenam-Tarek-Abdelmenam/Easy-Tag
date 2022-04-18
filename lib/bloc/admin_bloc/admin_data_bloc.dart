import 'package:auto_id/model/module/card_student.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:auto_id/model/repository/auth_repository.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../model/module/app_admin.dart';
import '../../model/repository/realtime_firebase.dart';
import '../../model/repository/web_sevices.dart';

part 'admin_data_event.dart';
part 'admin_data_state.dart';

class AdminDataBloc extends Bloc<AdminDataEvent, AdminDataStates> {
  AdminDataBloc() : super(GetInitialDataState.initial()) {
    on<StartDataOperations>(_startGettingDataHandler);
    on<CardDataChangedEvents>(_cardDataChangesHandler);
    on<SendConfigurationEvent>(_sendEspConfigHandler);
    on<SignOutEvent>(_signOutHandler);
    on<LoadGroupDataEvent>(_getGroupDataHandler);
    on<DeleteGroupIndex>(_deleteGroup);
  }

  static AppAdmin admin = AppAdmin.empty;
  final AdminDataRepository _adminDataRepository = AdminDataRepository();
  final WebServices _webServices = WebServices();

  ///******************** Event handler functions **************************/
  Future<void> _startGettingDataHandler(
      StartDataOperations event, Emitter emit) async {
    if (!event.currentUser.isEmpty) {
      emit(GetInitialDataState(
          status: AdminDataStatus.loading, cardStudent: CardStudent.empty));
      admin = event.currentUser;
      await _readInitialFireData(emit);
    }
  }

  void _cardDataChangesHandler(CardDataChangedEvents event, Emitter emit) {
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: state.cardStudent.edit(event.key, event.value),
        groupList: state.groupList));
  }

  Future<void> _getGroupDataHandler(
      LoadGroupDataEvent event, Emitter emit) async {
    print("Start get group data");
    emit(LoadGroupDataState.fromOldState(
        state, AdminDataStatus.loading, event.groupIndex,
        force: event.force));
    if (state.groupList[event.groupIndex].columnNames == null || event.force) {
      try {
        state.groupList[event.groupIndex] = await _webServices.getGroupData(
            event.groupIndex, state.groupList[event.groupIndex]);
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.loaded, event.groupIndex));
      } on DioErrors catch (err) {
        showToast(err.message, type: ToastType.error);
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.error, event.groupIndex,
            force: event.force));
      }
    } else {
      emit(LoadGroupDataState.fromOldState(
          state, AdminDataStatus.loaded, event.groupIndex));
    }
  }

  Future<void> _deleteGroup(DeleteGroupIndex event, Emitter emit) async {
    LoadGroupDataState.fromOldState(state, state.status, event.groupIndex,
        loadingSate: true);
    await _adminDataRepository
        .deleteGroup(state.groupList[event.groupIndex].name);
    state.groupList.removeAt(event.groupIndex);
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: state.cardStudent,
        groupList: state.groupList));
  }

  Future<void> _sendEspConfigHandler(
      SendConfigurationEvent event, Emitter emit) async {
    print("Send configurations");
    emit(SendEspDataState.fromOldState(state, AdminDataStatus.loading));
    try {
      bool success =
          await _webServices.sendCredentialsToEsp(event.name, event.pass);
      if (success) {
        showToast("Device connected successfully", type: ToastType.success);
        emit(SendEspDataState.fromOldState(state, AdminDataStatus.loaded));
      } else {
        emit(SendEspDataState.fromOldState(state, AdminDataStatus.error));
        showToast("Error happened ,make sure Your WIFI and pass is correct");
      }
    } on DioErrors catch (err) {
      emit(SendEspDataState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
      showToast("Make sure you connect to device wifi and try again",
          type: ToastType.error);
    }
  }

  Future<void> _signOutHandler(SignOutEvent event, Emitter emit) async {
    emit(SignOutState.fromOldState(state, AdminDataStatus.loading));
    await _adminDataRepository.cancelListener();
    await AuthRepository.signOut();
    emit(SignOutState(status: AdminDataStatus.loaded));
  }

  ///***************** need events and states **************************/

  Future<void> deleteUser(int userIndex, int groupIndex) async {
    try {
      await _webServices.deleteStudentFromSheet(userIndex, groupIndex);
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> sendEditData(int groupIndex, String id, Map dataToSent) async {
    try {
      await _webServices.sendStudentNewData(groupIndex, id, dataToSent);
      CardStudent student = state.cardStudent;
      if (student.state == StudentState.newStudent && student.id == id) {
        student = student.copyWith(
            name: dataToSent['Name'],
            groupIndex: groupIndex,
            state: StudentState.notRegistered);
        _adminDataRepository.updateCardState();
        // user edited successfully
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> getUserData(int groupIndex, int userIndex) async {
    try {
      Map<String, dynamic> showedUserData =
          await _webServices.getUserData(userIndex, groupIndex);
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> createSpreadSheet(
      String groupName, List<String> columnNames, Emitter emit) async {
    try {
      String id = await _webServices.createSpreadSheet(groupName);
      addSheetColumnNames(id, groupName, columnNames, emit);
      // user deleted successfully
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> addSheetColumnNames(String id, String groupName,
      List<String> columnNames, Emitter emit) async {
    try {
      bool success =
          await _webServices.addColumnNames(id, groupName, columnNames);
      if (success) {
        await _createGroup(id, groupName, emit);
      } else {
        showToast("can't Create group,try again", type: ToastType.error);
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  ///************************ Helper functions **************************/
  Future<void> _createGroup(String id, String name, Emitter emit) async {
    GroupDetails newGroup = GroupDetails(name: name, id: id);
    await _adminDataRepository.createGroup(newGroup);
    state.groupList.insert(0, newGroup);
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: state.cardStudent,
        groupList: state.groupList));
  }

  Future<void> _readInitialFireData(Emitter emit) async {
    if (await _checkConnectivity()) {
      CardStudent cardStudent = await _adminDataRepository.readAdminData();
      List<GroupDetails> groups = await _adminDataRepository.getGroupNames();
      emit(GetInitialDataState(
          status: AdminDataStatus.loaded,
          cardStudent: cardStudent,
          groupList: groups));
      _adminDataRepository.buildListener((key, value) {
        add(CardDataChangedEvents(key, value));
      });
    } else {
      showToast("Please Check your internet connection");
      emit(GetInitialDataState(status: AdminDataStatus.error));
    }
  }

  Future<bool> _checkConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    return ([
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
      ConnectivityResult.ethernet
    ].contains(connectivityResult));
  }
}
