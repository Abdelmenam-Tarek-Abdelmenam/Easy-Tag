import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/course.dart';

part 'student_data_event.dart';
part 'student_data_state.dart';

class StudentDataBloc extends Bloc<StudentDataEvent, StudentDataStates> {
  StudentDataBloc() : super(GetInitialDataState.initial()) {
    on<StartStudentOperations>(_startGettingDataHandler);
  }

  void _startGettingDataHandler(StartStudentOperations event, Emitter emit) {}
}
