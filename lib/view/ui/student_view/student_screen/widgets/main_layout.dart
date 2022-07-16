import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../model/module/course.dart';
import '../../../../shared/functions/navigation_functions.dart';
import '../../../../shared/widgets/toast_helper.dart';
import '../../details_screen/details_screen.dart';
import '../../main_screen/widgets/loading_card.dart';

class UserScreenLayout extends StatelessWidget {
  const UserScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: myCourses(context),
    );
  }

  Widget coursePhoto(logo) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(logo,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    color: ColorManager.lightGrey,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: ColorManager.darkGrey,
                    ),
                  )),
        ),
      );

  Widget myCourses(BuildContext context) {
    return BlocBuilder<StudentDataBloc, StudentDataStates>(
        buildWhen: (_, state) => state is GetInitialDataState,
        builder: (context, state) {
          if (state.status == StudentDataStatus.loading) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "My courses",
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorManager.darkGrey,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        showToast("Wait the data to load",
                            type: ToastType.info);
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
                  height: 10,
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
            if (state.registeredId.isEmpty) {
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
              List<String> ids = state.registeredId;
              List<Course> courses = state.allCourses
                  .where((element) => ids.contains(element.id))
                  .toList();
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
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
                    margin: const EdgeInsets.all(10),
                    color: ColorManager.blackColor.withOpacity(0.8),
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                courses[index].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: Text(
                                '${index + 1}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              tileColor: Colors.white,
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    navigateAndPush(
                                        context, DetailsScreen(courses[index]));
                                  },
                                ),
                              ),
                              subtitle: Text(courses[index].category +
                                  ' - ' +
                                  courses[index].inPlace),
                              focusColor: Colors.white,
                              textColor: Colors.white,
                              //onTap: (){ navigateAndPush(context, DetailsScreen(courses[index]));},
                            ),
                            index != courses.length - 1
                                ? const Divider(color: Colors.white)
                                : Container(),
                          ],
                        );
                      },
                      shrinkWrap: true,
                      itemCount: courses.length > 5 ? 5 : courses.length,
                    ),
                  ),
                ],
              );
            }
          }
        });
  }
}
