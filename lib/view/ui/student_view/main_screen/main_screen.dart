import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/home_app_bar.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/list_view_filter_buttons.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/loading_card.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/dialog.dart';
import '../../../shared/widgets/powered_by_navigation_bar.dart';
import '../../qr/qr_read.dart';
import '../student_screen/student_screen.dart';

class StudentMainScreen extends StatelessWidget {
  StudentMainScreen({Key? key}) : super(key: key);

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => dialog(context),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: appBar('EME-IH-Borg', actions: [
            ProfileIcon(
              profileHandler: () {
                navigateAndPush(context, const StudentScreen());
              },
            ),
            const SizedBox(
              width: 10,
            )
          ]),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.qr_code_scanner),
              backgroundColor: ColorManager.mainBlue,
              onPressed: () {
                navigateAndPush(context, const QrReadScreen());
              }),
          bottomNavigationBar: poweredBy(),
          backgroundColor: ColorManager.whiteColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  const SizedBox(height: 15,),
                  Row(
                    children: const [
                      Icon(Icons.search),
                      Text(
                        'Results',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
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
                                children: [
                                  Image.asset(
                                    'images/icons/empty_icon.png',
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "No Results",
                                    style: TextStyle(
                                        //color: ColorManager.lightGrey,
                                        fontSize: 18),
                                  )
                                ],
                              );
                            }
                            return ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return CourseCardDesign(
                                    state.getCourses[index],
                                  );
                                },
                                separatorBuilder: (_, __) => const SizedBox(
                                      height: 8,
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
