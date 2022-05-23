import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/student_exam_bloc/student_exam_bloc.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/widgets/app_bar.dart';

class SolveQuestionsScreen extends StatelessWidget {
  const SolveQuestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: appBar("Sovle Questions"),
        backgroundColor: ColorManager.whiteColor,
        body: SingleChildScrollView(
          child: BlocConsumer<StudentExamBloc, StudentExamStates>(
            listener: (context, state) => {
              if (state.status == AdminDataStatus.loaded)
                Navigator.of(context).pop()
            },
            builder: (context, state) => Container(),
          ),
        ),
      ),
    );
  }
}
