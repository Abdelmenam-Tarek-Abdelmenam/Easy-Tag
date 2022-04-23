import 'package:auto_id/model/module/card_student.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:auto_id/model/module/students.dart';
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
    on<StartAdminOperations>(_startGettingDataHandler);
    on<CardDataChangedEvents>(_cardDataChangesHandler);
    on<CreateGroupEvent>(_createSpreadSheet);
    on<SendConfigurationEvent>(_sendEspConfigHandler);
    on<SignOutEvent>(_signOutHandler);
    on<LoadGroupDataEvent>(_getGroupDataHandler);
    on<DeleteGroupIndex>(_deleteGroupHandler);
    on<DeleteStudentIndex>(_deleteStudentHandler);
    on<EditStudentEvent>(_editStudentHandler);
  }

  static AppAdmin admin = AppAdmin.empty;
  final AdminDataRepository _adminDataRepository = AdminDataRepository();
  final WebServices _webServices = WebServices();

  ///******************** Event handler functions **************************/
  Future<void> _startGettingDataHandler(
      StartAdminOperations event, Emitter emit) async {
    if (!event.currentUser.isEmpty || event.currentUser.isAdmin) {
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

  Future<void> _createSpreadSheet(CreateGroupEvent event, Emitter emit) async {
    try {
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.loading));
      String id = await _webServices.createSpreadSheet(event.groupData['name'],
          event.groupData['instructorsEmails'], event.groupData['titles']);
      GroupDetails newGroup = GroupDetails(id: id, json: event.groupData);
      newGroup.students = [];
      await _adminDataRepository.createGroup(newGroup);
      state.groupList.insert(0, newGroup);
      emit(GetInitialDataState(
          status: AdminDataStatus.loaded,
          cardStudent: state.cardStudent,
          groupList: state.groupList));
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.loaded));
    } on DioErrors catch (err) {
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _getGroupDataHandler(
      LoadGroupDataEvent event, Emitter emit) async {
    print("Start get group data");
    emit(LoadGroupDataState.fromOldState(
        state, AdminDataStatus.loading, event.groupIndex,
        force: event.force));
    if (state.groupList[event.groupIndex].students == null || event.force) {
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

  Future<void> _deleteGroupHandler(DeleteGroupIndex event, Emitter emit) async {
    LoadGroupDataState.fromOldState(state, state.status, event.groupIndex,
        loadingSate: true);
    await _adminDataRepository
        .deleteGroup(state.groupList[event.groupIndex].id);
    state.groupList.removeAt(event.groupIndex);
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: state.cardStudent,
        groupList: state.groupList));
  }

  Future<void> _deleteStudentHandler(
      DeleteStudentIndex event, Emitter emit) async {
    try {
      emit(DeleteUserState.fromOldState(state, AdminDataStatus.loading));
      bool response = await _webServices.deleteStudentFromSheet(
          state.groupList[event.groupIndex].students![event.userIndex].id,
          state.groupList[event.groupIndex].id);
      if (response) {
        state.groupList[event.groupIndex].students!.removeAt(event.userIndex);
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.loaded, event.groupIndex,
            force: false));
      } else {
        emit(DeleteUserState.fromOldState(state, AdminDataStatus.error));
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
      emit(DeleteUserState.fromOldState(state, AdminDataStatus.error));
    }
  }

  Future<void> _editStudentHandler(EditStudentEvent event, Emitter emit) async {
    try {
      emit(EditUserState.fromOldState(state, AdminDataStatus.loading));
      String groupId = state.groupList[event.groupIndex].id;
      bool response = await _webServices.editStudentData(groupId, event.data);
      if (response) {
        CardStudent student = state.cardStudent;
        state.groupList[event.groupIndex].students![event.studentIndex] =
            Student.fromJson(event.data);
        if (student.state == StudentState.newStudent &&
            student.id == event.data['ID']) {
          student = student.copyWith(
              name: event.data['Name'],
              groupIndex: event.groupIndex,
              state: StudentState.notRegistered);
          _adminDataRepository.updateCardState();
        }
        emit(GetInitialDataState(
            status: AdminDataStatus.loaded,
            cardStudent: state.cardStudent,
            groupList: state.groupList));
        emit(EditUserState.fromOldState(state, AdminDataStatus.loaded));
      } else {
        emit(EditUserState.fromOldState(state, AdminDataStatus.error));
      }
    } on DioErrors catch (err) {
      emit(EditUserState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
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
  Future<void> getUserData(String userId, String sheetId) async {
    try {
      Student student = await _webServices.getUserData(userId, sheetId);
      print(student.name);
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  ///************************ Helper functions **************************/

  Future<void> _readInitialFireData(Emitter emit) async {
    if (await _checkConnectivity()) {
      CardStudent cardStudent = await _adminDataRepository.readAdminData();
      List<GroupDetails> groups = await _adminDataRepository.getGroupsData();
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
