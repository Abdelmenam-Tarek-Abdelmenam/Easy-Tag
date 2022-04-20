// ignore: must_be_immutable
import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/student_view/main_screen/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../shared/widgets/toast_helper.dart';
import '../../main_screen/widgets/loading_card.dart';

class UserScreenLayout extends StatelessWidget {
  UserScreenLayout({Key? key}) : super(key: key);

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            myCourses(context),
          ],
        ),
      ),
    );
  }

  Widget myCourses(BuildContext context) {
    return BlocBuilder<StudentDataBloc, StudentDataStates>(
        builder: (context, state) {
      if (state.status == StudentDataStatus.loading) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My courses",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    showToast("Wait the data to load", type: ToastType.info);
                  },
                  child: const Text(
                    "View aLL >>",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorManager.mainBlue,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 350,
              height: 200,
              decoration: const BoxDecoration(
                  color: ColorManager.mainBlue,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: const LoadingView(count: 1)),
            ),
          ],
        );
      } else {
        if (true) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My courses",
                    style: TextStyle(
                        fontSize: 18,
                        color: ColorManager.darkGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      showToast("no courses yet", type: ToastType.info);
                    },
                    child: const Text(
                      "View aLL >>",
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorManager.mainBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Container(
                width: 350,
                height: 200,
                decoration: const BoxDecoration(
                    color: ColorManager.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.pending_actions,
                      color: ColorManager.whiteColor,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("No courses yet",
                        style: TextStyle(color: ColorManager.whiteColor))
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My courses",
                    style: TextStyle(
                        fontSize: 18,
                        color: ColorManager.darkGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: state.courses.length > 5,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "View aLL >>",
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorManager.mainBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: 350,
                height: 200,
                decoration: const BoxDecoration(
                    color: ColorManager.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: controller, // PageController
                          itemBuilder: (_, index) => Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: CourseCardDesign(
                                  state.courses[index],
                                ),
                              ),
                          itemCount: state.courses.length > 5
                              ? 5
                              : state.courses.length),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SmoothPageIndicator(
                        controller: controller, // PageController
                        count:
                            state.courses.length > 5 ? 5 : state.courses.length,
                        effect: const WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            dotColor: ColorManager.whiteColor,
                            activeDotColor:
                                ColorManager.darkGrey), // your preferred effect
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      }
    });
  }
}
