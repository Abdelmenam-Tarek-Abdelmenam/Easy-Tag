import 'package:auto_id/model/module/app_admin.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/course.dart';
import '../../model/repository/realtime_firebase.dart';
import '../../model/repository/web_sevices.dart';
import '../../view/shared/widgets/toast_helper.dart';

part 'student_data_event.dart';
part 'student_data_state.dart';

class StudentDataBloc extends Bloc<StudentDataEvent, StudentDataStates> {
  StudentDataBloc() : super(GetInitialDataState.initial()) {
    on<StartStudentOperations>(_startGettingDataHandler);
    on<RegisterStudentEvent>(_addNewStudentHandler);
  }

  final WebServices _webServices = WebServices();
  final AdminDataRepository _adminDataRepository = AdminDataRepository();

  static AppAdmin student = AppAdmin.empty;

  void _startGettingDataHandler(StartStudentOperations event, Emitter emit) {
    if (!event.user.isEmpty || !event.user.isAdmin) {
      emit(GetInitialDataState(status: StudentDataStatus.loading));
      if (!event.user.isEmpty && !event.user.isAdmin) {
        student = event.user;
        _readInitialFireData(emit);
      }
      emit(GetInitialDataState(
          status: StudentDataStatus.loaded,
          courses: const [],
          category: "ALL"));
    }
  }

  Future<void> _addNewStudentHandler(
      RegisterStudentEvent event, Emitter emit) async {
    try {
      emit(RegisterUserState.fromOldState(state, StudentDataStatus.loading));
      bool response =
          await _webServices.sendStudentNewData(event.groupId, event.data);

      if (response) {
        emit(RegisterUserState.fromOldState(state, StudentDataStatus.loaded));

        /// add to my courses
      } else {
        emit(RegisterUserState.fromOldState(state, StudentDataStatus.error));
      }
    } on DioErrors catch (err) {
      emit(RegisterUserState.fromOldState(state, StudentDataStatus.error));
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> _readInitialFireData(Emitter emit) async {
    if (await _checkConnectivity()) {
      List<Course> groups = await _adminDataRepository.getGroupsData();
      emit(GetInitialDataState(
          status: StudentDataStatus.loaded, courses: groups));
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
