import 'package:auto_id/model/module/app_admin.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/course.dart';

part 'student_data_event.dart';
part 'student_data_state.dart';

class StudentDataBloc extends Bloc<StudentDataEvent, StudentDataStates> {
  StudentDataBloc() : super(GetInitialDataState.initial()) {
    on<StartStudentOperations>(_startGettingDataHandler);
  }

  static AppAdmin student = AppAdmin.empty;

  void _startGettingDataHandler(StartStudentOperations event, Emitter emit) {
    if (!event.user.isEmpty || !event.user.isAdmin) {
      emit(GetInitialDataState(status: StudentDataStatus.loading));
      student = event.user;
      emit(GetInitialDataState(
          status: StudentDataStatus.loaded,
          courses: const [],
          category: "ALL"));
    }
  }
}
