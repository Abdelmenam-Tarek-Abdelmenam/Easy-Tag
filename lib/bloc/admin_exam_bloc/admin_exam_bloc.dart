import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/exam_question.dart';
import '../../model/repository/fire_store.dart';

part 'admin_exam_event.dart';
part 'admin_exam_state.dart';

class AdminExamBloc extends Bloc<AdminExamEvent, AdminExamStates> {
  AdminExamBloc() : super(GetInitialExamState.initial()) {
    on<UploadQuizEvent>(_addQuizToFireStore);
  }

  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  _addQuizToFireStore(UploadQuizEvent event, Emitter emit) async {
    try {
      print(state.quiz.toJson);
      await _fireStoreRepository.setAllQuestions(state.id, state.quiz);
    } catch (e) {
      print(e);
    }
  }

  getCourseQuestion(String id) {
    _fireStoreRepository.getAllQuestions(id);
  }
}
