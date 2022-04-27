// ignore_for_file: must_be_immutable

part of "student_data_bloc.dart";

enum StudentDataStatus { initial, loading, loaded, error }

class StudentDataStates extends Equatable {
  late StudentDataStatus status;
  String category;
  late List<Course> allCourses;
  late List<String> courses;
  late List<String> registeredId;

  StudentDataStates(
      {required this.status,
      required this.courses,
      required this.allCourses,
      required this.category,
      required this.registeredId});

  List<Course> get getCourses =>
      allCourses.where((element) => courses.contains(element.id)).toList();

  @override
  List<Object?> get props =>
      [status, courses.length, category, registeredId.length];
}

class GetInitialDataState extends StudentDataStates {
  GetInitialDataState(
      {StudentDataStatus status = StudentDataStatus.initial,
      List<String> courses = const [],
      List<Course> all = const [],
      String category = "ALL",
      List<String> ids = const []})
      : super(
            allCourses: all,
            status: status,
            courses: courses,
            category: category,
            registeredId: ids);

  factory GetInitialDataState.initial() {
    return GetInitialDataState();
  }
}

class RegisterUserState extends StudentDataStates {
  RegisterUserState(
      {StudentDataStatus status = StudentDataStatus.initial,
      List<String> courses = const [],
      List<Course> all = const [],
      String category = "ALL",
      List<String> ids = const []})
      : super(
            allCourses: all,
            status: status,
            courses: courses,
            category: category,
            registeredId: ids);

  factory RegisterUserState.fromOldState(
      StudentDataStates oldState, StudentDataStatus status) {
    return RegisterUserState(
        courses: oldState.courses,
        category: oldState.category,
        status: status,
        all: oldState.allCourses,
        ids: oldState.registeredId);
  }
}

// class EditStudentState extends StudentDataStates {
//   EditStudentState(
//       {StudentDataStatus status = StudentDataStatus.initial,
//       List<String> courses = const [],
//       List<Course> all = const [],
//       String category = "ALL",
//       List<String> ids = const []})
//       : super(
//             allCourses: all,
//             status: status,
//             courses: courses,
//             category: category,
//             registeredId: ids);
//   factory EditStudentState.fromOldState(
//       StudentDataStates oldState, StudentDataStatus status) {
//     return EditStudentState(
//         courses: oldState.courses,
//         category: oldState.category,
//         status: status,
//         all: oldState.allCourses,
//         ids: oldState.registeredId);
//   }
// }

class GetStudentDataState extends StudentDataStates {
  Student? student;
  GetStudentDataState(
      {this.student,
      StudentDataStatus status = StudentDataStatus.initial,
      List<String> courses = const [],
      List<Course> all = const [],
      String category = "ALL",
      List<String> ids = const []})
      : super(
            allCourses: all,
            status: status,
            courses: courses,
            category: category,
            registeredId: ids);
  factory GetStudentDataState.fromOldState(
      StudentDataStates oldState, StudentDataStatus status, Student? student) {
    return GetStudentDataState(
        student: student,
        courses: oldState.courses,
        category: oldState.category,
        status: status,
        all: oldState.allCourses,
        ids: oldState.registeredId);
  }
}

class QrReadState extends StudentDataStates {
  QrReadState(
      {StudentDataStatus status = StudentDataStatus.initial,
      List<String> courses = const [],
      List<Course> all = const [],
      String category = "ALL",
      List<String> ids = const []})
      : super(
            allCourses: all,
            status: status,
            courses: courses,
            category: category,
            registeredId: ids);

  factory QrReadState.fromOldState(
      StudentDataStates oldState, StudentDataStatus status) {
    return QrReadState(
        courses: oldState.courses,
        category: oldState.category,
        status: status,
        all: oldState.allCourses,
        ids: oldState.registeredId);
  }
}
