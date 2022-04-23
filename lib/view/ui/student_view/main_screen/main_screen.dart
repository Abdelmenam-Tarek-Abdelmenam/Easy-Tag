import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/home_app_bar.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/list_view_filter_buttons.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/loading_card.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class StudentMainScreen extends StatelessWidget {
  StudentMainScreen({Key? key}) : super(key: key);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorManager.lightBlue,
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SmartRefresher(
              enablePullUp: false,
              controller: _refreshController,
              onRefresh: () {
                context
                    .read<StudentDataBloc>()
                    .add(StartStudentOperations(StudentDataBloc.student));
                _refreshController.refreshCompleted();
              },
              child: Column(
                children: [
                  const HomeAppBar(),
                  const CategoryButtonsList(),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: BlocBuilder<StudentDataBloc, StudentDataStates>(
                        buildWhen: (_, state) =>
                            state is GetInitialDataState, // check state
                        builder: (context, state) {
                          if (state.status == StudentDataStatus.loading) {
                            return Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.5),
                                highlightColor: Colors.white,
                                child: const LoadingView());
                          } else {
                            if (state.courses.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.table_rows_outlined,
                                    color: ColorManager.lightGrey,
                                    size: 70,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "No Courses",
                                    style: TextStyle(
                                        color: ColorManager.lightGrey,
                                        fontSize: 18),
                                  )
                                ],
                              );
                            }
                            return ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) => CourseCardDesign(
                                      state.getCourses[index],
                                    ),
                                separatorBuilder: (_, __) => const SizedBox(
                                      height: 15,
                                    ),
                                itemCount: state.courses.length);
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
