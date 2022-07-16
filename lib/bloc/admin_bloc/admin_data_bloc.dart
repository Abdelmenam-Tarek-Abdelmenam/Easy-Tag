import 'package:auto_id/model/module/card_student.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:auto_id/model/repository/auth_repository.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../model/module/app_admin.dart';
import '../../model/repository/fire_store.dart';
import '../../model/repository/realtime_firebase.dart';
import '../../model/repository/web_sevices.dart';
import '../../view/shared/platforms.dart';

part 'admin_data_event.dart';
part 'admin_data_state.dart';

class AdminDataBloc extends Bloc<AdminDataEvent, AdminDataStates> {
  AdminDataBloc() : super(GetInitialDataState.initial()) {
    on<StartAdminOperations>(_startGettingDataHandler);
    on<CardDataChangedEvents>(_cardDataChangesHandler);
    on<CreateGroupEvent>(_createSpreadSheet);
    on<EditGroupEvent>(_editSpreadSheet);
    on<SendConfigurationEvent>(_sendEspConfigHandler);
    on<SignOutEvent>(_signOutHandler);
    on<LoadGroupDataEvent>(_getGroupDataHandler);
    on<DeleteGroupIndex>(_deleteGroupHandler);
    on<DeleteStudentIndex>(_deleteStudentHandler);
    on<EditStudentEvent>(_editStudentHandler);
    on<AddRfIdEvent>(_editStudentRfIdHandler);
    on<SearchByNameEvent>(_searchByNameHandler);
  }

  static AppAdmin admin = AppAdmin.empty;
  final AdminDataRepository _adminDataRepository = AdminDataRepository();
  final WebServices _webServices = WebServices();

  ///******************** Event handler functions **************************/
  Future<void> _startGettingDataHandler(
      StartAdminOperations event, Emitter emit) async {
    if (!event.currentUser.isEmpty || await event.currentUser.isAdmin) {
      emit(GetInitialDataState(
          status: AdminDataStatus.loading, cardStudent: CardStudent.empty));
      admin = event.currentUser;
      Platform.execute(
          mobile: () async {
            if (FirebaseMessaging.instance.isSupported()) {
              FirebaseMessaging.instance.subscribeToTopic(admin.id);
            }
          },
          web: () async {});

      await _readInitialFireData(emit);
    }
  }

  void _cardDataChangesHandler(CardDataChangedEvents event, Emitter emit) {
    emit(GetInitialDataState.fromOldState(state, AdminDataStatus.loading));
    state.cardStudent = state.cardStudent.edit(event.key, event.value);
    emit(GetInitialDataState.fromOldState(state, AdminDataStatus.loaded));
  }

  Future<void> _createSpreadSheet(CreateGroupEvent event, Emitter emit) async {
    try {
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.loading));
      String id = await _webServices.createSpreadSheet(event.groupData['name'],
          event.groupData['instructorsEmails'], event.groupData['titles']);
      GroupDetails newGroup = GroupDetails(id: id, json: event.groupData);
      newGroup.students = [];
      await _adminDataRepository.createGroup(newGroup);
      state.allGroupList.insert(0, newGroup);
      state.usingIds.insert(0, newGroup.id);
      // NotificationSender sender = NotificationSender();
      // sender.postData(
      //     title: "EME IH Announcement",
      //     body: 'New ${event.groupData['category']}s is available now');
      emit(GetInitialDataState.fromOldState(state, AdminDataStatus.loaded));
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.loaded));
    } on DioErrors catch (err) {
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _editSpreadSheet(EditGroupEvent event, Emitter emit) async {
    try {
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.loading));
      await _adminDataRepository.editCourse(event.id, event.groupData);
      int groupIndex = state.getGroupIndex(event.id);
      state.allGroupList[groupIndex].editCourse(event.groupData);
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.loaded));
    } on DioErrors catch (err) {
      emit(CreateGroupState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _getGroupDataHandler(
      LoadGroupDataEvent event, Emitter emit) async {
    emit(LoadGroupDataState.fromOldState(
        state, AdminDataStatus.loading, event.groupIndex,
        force: event.force));
    int realGroupIndex = state.getGroupIndex(state.usingIds[event.groupIndex]);
    if (state.allGroupList[realGroupIndex].students == null || event.force) {
      try {
        state.allGroupList[realGroupIndex] = await _webServices.getGroupData(
            event.groupIndex, state.allGroupList[realGroupIndex]);
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.loaded, event.groupIndex));
      } on DioErrors catch (err) {
        showToast(err.message, type: ToastType.error);
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.error, event.groupIndex,
            force: event.force));
      } catch (err) {
        showToast("An handling error happened", type: ToastType.error);
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
    await _adminDataRepository.deleteGroup(state.usingIds[event.groupIndex]);
    state.removeId(state.usingIds[event.groupIndex]);
    emit(GetInitialDataState.fromOldState(state, AdminDataStatus.loaded));
  }

  Future<void> _deleteStudentHandler(
      DeleteStudentIndex event, Emitter emit) async {
    try {
      emit(DeleteUserState.fromOldState(state, AdminDataStatus.loading));
      String groupId = state.usingIds[event.groupIndex];
      bool response = await _webServices.deleteStudentFromSheet(
          state.allGroupList[state.getGroupIndex(groupId)]
              .students![event.userIndex].id,
          groupId);
      if (response) {
        await FireStoreRepository().deleteCourse(
            groupId,
            state.allGroupList[state.getGroupIndex(groupId)]
                .students![event.userIndex].id);
        state.allGroupList[state.getGroupIndex(groupId)].students!
            .removeAt(event.userIndex);

        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.loaded, event.groupIndex,
            force: false));
      } else {
        emit(DeleteUserState.fromOldState(state, AdminDataStatus.error));
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
      emit(DeleteUserState.fromOldState(state, AdminDataStatus.error));
    } catch (err) {
      showToast("An error happened", type: ToastType.error);
      emit(DeleteUserState.fromOldState(state, AdminDataStatus.error));
    }
  }

  Future<void> _editStudentHandler(EditStudentEvent event, Emitter emit) async {
    try {
      emit(EditUserState.fromOldState(state, AdminDataStatus.loading));
      String groupId = state.usingIds[event.groupIndex];
      bool response = await _webServices.editStudentData(groupId, event.data);
      if (response) {
        CardStudent student = state.cardStudent;
        state.allGroupList[state.getGroupIndex(groupId)]
            .students![event.studentIndex]
            .editData(event.data);
        if (student.state == StudentState.newStudent &&
            student.name == event.data['Name']) {
          student = student.copyWith(
              name: event.data['Name'],
              groupIndex: event.groupIndex,
              state: StudentState.notRegistered);
        }
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.loaded, event.groupIndex));
        emit(EditUserState.fromOldState(state, AdminDataStatus.loaded));
      } else {
        emit(EditUserState.fromOldState(state, AdminDataStatus.error));
      }
    } on DioErrors catch (err) {
      emit(EditUserState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _editStudentRfIdHandler(AddRfIdEvent event, Emitter emit) async {
    try {
      emit(EditUserState.fromOldState(state, AdminDataStatus.loading));
      event.data['UID'] = event.studentId;
      bool response =
          await _webServices.editStudentData(event.groupId, event.data);
      if (response) {
        CardStudent student = state.cardStudent;
        int groupIndex = state.allGroupList
            .indexWhere((element) => element.id == event.groupId);
        if (student.state == StudentState.newStudent &&
            student.id == event.data['RFID']) {
          state.cardStudent = student.copyWith(
              name: event.studentName,
              groupIndex: groupIndex,
              state: StudentState.notRegistered);
          _adminDataRepository.updateCardState();
        }
        emit(LoadGroupDataState.fromOldState(
            state, AdminDataStatus.loaded, groupIndex));
        emit(EditUserState.fromOldState(state, AdminDataStatus.loaded));
      } else {
        showToast("Can't ADD RFID ", type: ToastType.error);
        emit(EditUserState.fromOldState(state, AdminDataStatus.error));
      }
    } on DioErrors catch (err) {
      emit(EditUserState.fromOldState(state, AdminDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _sendEspConfigHandler(
      SendConfigurationEvent event, Emitter emit) async {
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
    Platform.execute(
        mobile: () async {
          if (FirebaseMessaging.instance.isSupported()) {
            FirebaseMessaging.instance.unsubscribeFromTopic(admin.id);
          }
        },
        web: () async {});

    emit(SignOutState(status: AdminDataStatus.loaded));
  }

  void _searchByNameHandler(SearchByNameEvent event, Emitter emit) {
    emit(GetInitialDataState.fromOldState(state, AdminDataStatus.loading));

    state.usingIds = state.allGroupList
        .where((element) =>
            element.name.toLowerCase().contains(event.subName.toLowerCase()))
        .map((e) => e.id)
        .toList();
    emit(GetInitialDataState.fromOldState(state, AdminDataStatus.loaded));
  }

  ///************************ Helper functions **************************/

  Future<void> _readInitialFireData(Emitter emit) async {
    if (await _checkConnectivity()) {
      CardStudent cardStudent = await _adminDataRepository.readAdminData();
      List<GroupDetails> groups = await _adminDataRepository.getGroupsData();
      emit(GetInitialDataState(
          status: AdminDataStatus.loaded,
          cardStudent: cardStudent,
          groupList: groups,
          groupIds: groups.map((e) => e.id).toList()));
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
