import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/repository/fire_store.dart';

part 'admin_exam_event.dart';
part 'admin_exam_state.dart';

class AdminExamBloc extends Bloc<AdminExamEvent, AdminExamStates> {
  AdminExamBloc() : super(GetInitialExamState.initial());

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  getCourseQuestion(String id) {
    _fireStoreRepository.getAllQuestions(id);
  }
}
