import 'package:auto_id/model/module/app_admin.dart';
import 'package:auto_id/model/repository/fire_store.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/course.dart';
import '../../model/module/students.dart';
import '../../model/repository/realtime_firebase.dart';
import '../../model/repository/web_sevices.dart';
import '../../view/shared/widgets/toast_helper.dart';

part 'student_data_event.dart';
part 'student_data_state.dart';

class StudentDataBloc extends Bloc<StudentDataEvent, StudentDataStates> {
  StudentDataBloc() : super(GetInitialDataState.initial()) {
    on<StartStudentOperations>(_startGettingDataHandler);
    on<RegisterStudentEvent>(_addNewStudentHandler);
    on<ChangeFilterTypeEvent>(_filterUsingType);
    on<ChangeFilterNameEvent>(_filterUsingName);
    on<QrReadEvent>(_registerUserFromQr);
    on<WantUserDataEvent>(_readMyCourseDate);
    // on<EditMyStudentEvent>(_editStudentHandler);
  }

  final WebServices _webServices = WebServices();
  final AdminDataRepository _adminDataRepository = AdminDataRepository();
  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  static AppAdmin student = AppAdmin.empty;

  Future<void> _startGettingDataHandler(
      StartStudentOperations event, Emitter emit) async {
    if (!event.user.isEmpty || !(await event.user.isAdmin)) {
      emit(GetInitialDataState(status: StudentDataStatus.loading));
      if (!event.user.isEmpty && !(await event.user.isAdmin)) {
        student = event.user;
        await _readInitialFireData(emit);
      }
    }
  }

  Future<void> _addNewStudentHandler(
      RegisterStudentEvent event, Emitter emit) async {
    try {
      emit(RegisterUserState.fromOldState(state, StudentDataStatus.loading));
      bool response =
          await _webServices.sendStudentNewData(event.groupId, event.data);

      if (response) {
        await _fireStoreRepository.addCourse(event.groupId);
        state.registeredId.insert(0, event.groupId);
        emit(RegisterUserState.fromOldState(state, StudentDataStatus.loaded));
      } else {
        showToast("Data handling error", type: ToastType.error);
        emit(RegisterUserState.fromOldState(state, StudentDataStatus.error));
      }
    } on DioErrors catch (err) {
      emit(RegisterUserState.fromOldState(state, StudentDataStatus.error));
      showToast(err.message, type: ToastType.error);
    } catch (err) {
      emit(RegisterUserState.fromOldState(state, StudentDataStatus.error));
      showToast("Data handling error", type: ToastType.error);
    }
  }

  // Future<void> _editStudentHandler(
  //     EditMyStudentEvent event, Emitter emit) async {
  //   try {
  //     emit(EditStudentState.fromOldState(state, StudentDataStatus.loading));
  //     bool response =
  //         await _webServices.editStudentData(event.groupId, event.data);
  //     if (response) {
  //       emit(EditStudentState.fromOldState(state, StudentDataStatus.loaded));
  //     } else {
  //       emit(EditStudentState.fromOldState(state, StudentDataStatus.error));
  //     }
  //   } on DioErrors catch (err) {
  //     emit(EditStudentState.fromOldState(state, StudentDataStatus.error));
  //     showToast(err.message, type: ToastType.error);
  //   }
  // }

  Future<void> _readMyCourseDate(WantUserDataEvent event, Emitter emit) async {
    try {
      emit(GetStudentDataState.fromOldState(
          state, StudentDataStatus.loading, null));
      Student response =
          await _webServices.getUserData(student.id, event.groupId);
      emit(GetStudentDataState.fromOldState(
          state, StudentDataStatus.loaded, response));
    } on DioErrors catch (err) {
      emit(GetStudentDataState.fromOldState(
          state, StudentDataStatus.error, null));
      showToast(err.message, type: ToastType.error);
    }
  }

  void _filterUsingType(ChangeFilterTypeEvent event, Emitter emit) {
    if (event.newType == "ALL") {
      state.courses = state.allCourses.map((e) => e.id).toList();
    } else {
      state.courses = state.allCourses
          .where((element) => element.category == event.newType)
          .map((e) => e.id)
          .toList();
    }
    emit(GetInitialDataState(
        category: event.newType,
        status: StudentDataStatus.loaded,
        all: state.allCourses,
        courses: state.courses,
        ids: state.registeredId));
  }

  void _filterUsingName(ChangeFilterNameEvent event, Emitter emit) {
    emit(GetInitialDataState(
        category: state.category,
        status: StudentDataStatus.loading,
        courses: state.courses,
        all: state.allCourses,
        ids: state.registeredId));
    if (state.category == "ALL") {
      state.courses = state.allCourses
          .where((element) =>
              element.name.toLowerCase().contains(event.subName.toLowerCase()))
          .map((e) => e.id)
          .toList();
    } else {
      state.courses = state.allCourses
          .where((element) =>
              (element.category == state.category) &&
              (element.name
                  .toLowerCase()
                  .contains(event.subName.toLowerCase())))
          .map((e) => e.id)
          .toList();
    }
    emit(GetInitialDataState(
        category: state.category,
        status: StudentDataStatus.loaded,
        courses: state.courses,
        all: state.allCourses,
        ids: state.registeredId));
  }

  Future<void> _registerUserFromQr(QrReadEvent event, Emitter emit) async {
    try {
      emit(QrReadState.fromOldState(state, StudentDataStatus.loading));
      bool register = await _webServices.registerStudentAttendance(
          student.id, event.groupId);
      if (register) {
        emit(QrReadState.fromOldState(state, StudentDataStatus.loaded));
        showToast("Registered Successfully", type: ToastType.success);
      } else {
        emit(QrReadState.fromOldState(state, StudentDataStatus.error));
        showToast("Can't register this Student now");
      }
    } on DioErrors catch (err) {
      emit(QrReadState.fromOldState(state, StudentDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _readInitialFireData(Emitter emit) async {
    if (await _checkConnectivity()) {
      List<Course> all = await _adminDataRepository.getGroupsData();
      List<String> registeredCourses =
          await _fireStoreRepository.readAllCourses();
      emit(GetInitialDataState(
          status: StudentDataStatus.loaded,
          all: all,
          courses: all.map((e) => e.id).toList(),
          ids: registeredCourses));
    } else {
      showToast("Please Check your internet connection");
      emit(GetInitialDataState(status: StudentDataStatus.error));
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
