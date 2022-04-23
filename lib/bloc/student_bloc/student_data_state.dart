// ignore_for_file: must_be_immutable

part of "student_data_bloc.dart";

enum StudentDataStatus { initial, loading, loaded, error }

class StudentDataStates extends Equatable {
  late StudentDataStatus status;
  String category;
  late List<Course> courses;

  StudentDataStates(
      {required this.status, required this.courses, required this.category});

  @override
  List<Object?> get props => [status, courses.length, category];
}

class GetInitialDataState extends StudentDataStates {
  GetInitialDataState(
      {StudentDataStatus status = StudentDataStatus.initial,
      List<Course> courses = const [],
      String category = "ALL"})
      : super(status: status, courses: courses, category: category);

  factory GetInitialDataState.initial() {
    return GetInitialDataState();
  }
}

class RegisterUserState extends StudentDataStates {
  RegisterUserState(
      {StudentDataStatus status = StudentDataStatus.initial,
      List<Course> courses = const [],
      String category = "ALL"})
      : super(status: status, courses: courses, category: category);

  factory RegisterUserState.fromOldState(
      StudentDataStates oldState, StudentDataStatus status) {
    return RegisterUserState(
        courses: oldState.courses, category: oldState.category, status: status);
  }
}
