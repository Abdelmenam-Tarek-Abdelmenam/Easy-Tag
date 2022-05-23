part of "admin_exam_bloc.dart";

enum AdminExamStatus { initial, loading, loaded, error }

class AdminExamStates extends Equatable {
  final AdminExamStatus status;

  const AdminExamStates({required this.status});

  @override
  List<Object?> get props => [status];
}

class GetInitialExamState extends AdminExamStates {
  const GetInitialExamState({
    AdminExamStatus status = AdminExamStatus.initial,
  }) : super(
          status: status,
        );

  factory GetInitialExamState.initial() {
    return const GetInitialExamState(status: AdminExamStatus.initial);
  }
}
