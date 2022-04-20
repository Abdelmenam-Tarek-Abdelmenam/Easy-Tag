import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/student_view/details_screen/widgets/details_layout.dart';
import 'package:auto_id/view/ui/student_view/register_screen/register_screen.dart';
import 'package:flutter/material.dart';

import '../../../../model/module/course.dart';
import '../../../resources/color_manager.dart';

class DetailsScreen extends StatelessWidget {
  final Course course;

  const DetailsScreen(
    this.course, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  late String name;
    //   int? numberOfSessions;
    //   late int price;
    //   late String description;
    //   late String offer;
    //   late List<String> instructors;
    //   late String logo;
    //   late String date;
    //   late String category;
    //   late String inPlace;

    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 26,
                      color: ColorManager.mainBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55),
              child: DetailsLayout(course),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorManager.mainBlue),
                        foregroundColor:
                            MaterialStateProperty.all(ColorManager.whiteColor)),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      navigateAndPush(context, RegisterScreen(course));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
