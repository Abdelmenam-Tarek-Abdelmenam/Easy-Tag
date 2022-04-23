// ignore: must_be_immutable
import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';

import '../../../../shared/functions/navigation_functions.dart';
import '../../details_screen/details_screen.dart';

class CourseCardDesign extends StatelessWidget {
  final Course course;

  const CourseCardDesign(
    this.course, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 5),
      height: 200,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDetails(),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorManager.mainBlue),
                        foregroundColor:
                            MaterialStateProperty.all(ColorManager.whiteColor)),
                    onPressed: () {
                      navigateAndPush(context, DetailsScreen(course));
                    },
                    child: const Text("See details"))
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: coursePhoto(),
          )
        ],
      ),
    );
  }

  Widget textDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            course.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 26,
                color: ColorManager.mainBlue,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "${course.price} EGP",
            style: const TextStyle(
                fontSize: 20,
                color: ColorManager.darkGrey,
                fontWeight: FontWeight.w600),
          ),
          Text(
            course.offer + " offer",
            style: const TextStyle(
                fontSize: 16,
                color: ColorManager.darkGrey,
                fontWeight: FontWeight.w300),
          ),
          Text(
            "${course.category} - ${course.inPlace}",
            style: const TextStyle(
                fontSize: 14,
                color: ColorManager.mainBlue,
                fontWeight: FontWeight.w300),
          ),
          Text(
            course.date,
            style: const TextStyle(
                fontSize: 16,
                color: ColorManager.darkGrey,
                fontWeight: FontWeight.w800),
          ),
        ],
      );
  Widget coursePhoto() => Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.mainBlue, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(course.logo,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: ColorManager.lightGrey,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: ColorManager.darkGrey,
                    ),
                  )),
        ),
      );
}
