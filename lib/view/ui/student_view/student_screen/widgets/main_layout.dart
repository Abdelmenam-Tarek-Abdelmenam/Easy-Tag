// ignore: must_be_immutable
import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
                        color: ColorManager.mainOrange,
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
                  color: ColorManager.mainOrange,
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
                          color: ColorManager.mainOrange,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Container(
                width: 350,
                height: 200,
                decoration: const BoxDecoration(
                    color: ColorManager.mainOrange,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.pending_actions,
                      color: ColorManager.lightGrey,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("No courses yet",
                        style: TextStyle(color: ColorManager.lightGrey))
                  ],
                ),
              ),
            ],
          );
        } else {
          // return Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "favorites",
          //           style: Theme.of(context)
          //               .textTheme
          //               .headline1!
          //               .copyWith(fontSize: 16, color: darkGrayColor),
          //         ),
          //         Visibility(
          //           visible: state.favData.length > 5,
          //           child: TextButton(
          //             onPressed: () {
          //               navigateAndPush(context, const FavScreen());
          //             },
          //             child: Text(
          //               "View aLL >>",
          //               style: Theme.of(context)
          //                   .textTheme
          //                   .headline1!
          //                   .copyWith(fontSize: 14.sp, color: darkYellow),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5.h,
          //     ),
          //     Container(
          //       width: 350.w,
          //       height: 200.h,
          //       decoration: BoxDecoration(
          //           gradient: themeGradient,
          //           borderRadius: BorderRadius.all(Radius.circular(15.r))),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Expanded(
          //             child: PageView.builder(
          //                 scrollDirection: Axis.horizontal,
          //                 controller: controller, // PageController
          //                 itemBuilder: (_, index) => Padding(
          //                       padding: EdgeInsets.only(top: 40.h),
          //                       child: ProductCard(
          //                         vehicle: state.favData[index],
          //                         index: -1,
          //                       ),
          //                     ),
          //                 itemCount: state.favData.length > 5
          //                     ? 5
          //                     : state.favData.length),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: SmoothPageIndicator(
          //               controller: controller, // PageController
          //               count:
          //                   state.favData.length > 5 ? 5 : state.favData.length,
          //               effect: WormEffect(
          //                   dotHeight: 8.r,
          //                   dotWidth: 8.r,
          //                   dotColor: whiteColor,
          //                   activeDotColor:
          //                       darkGrayColor), // your preferred effect
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // );
        }
      }
    });
  }
}
