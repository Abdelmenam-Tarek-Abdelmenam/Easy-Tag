// ignore: must_be_immutable
import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/admin_view/add_group/widgets/view_photo.dart';
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
    return Card(
      elevation: 0,
      color: ColorManager.lightBlue.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //const SizedBox(width: 8,),
                  Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 22,
                        color: ColorManager.blackColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
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
                              backgroundColor: MaterialStateProperty.all(
                                  ColorManager.lightBlue),
                              foregroundColor: MaterialStateProperty.all(
                                  ColorManager.whiteColor)),
                          onPressed: () {
                            navigateAndPush(context, DetailsScreen(course));
                          },
                          child: const Text("More details"))
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: coursePhoto(context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${course.price} EGP",
            style: const TextStyle(
                fontSize: 20,
                color: ColorManager.darkGrey,
                fontWeight: FontWeight.w800),
          ),
          Visibility(
            visible: course.offer.isNotEmpty,
            child: Text(
              course.offer,
              style: const TextStyle(
                  fontSize: 25,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Text(
            "${course.category} - ${course.inPlace}",
            style: const TextStyle(
                fontSize: 18,
                color: ColorManager.mainBlue,
                fontWeight: FontWeight.w300),
          ),
          Text(
            course.date,
            style: const TextStyle(
                fontSize: 18,
                color: ColorManager.darkGrey,
                fontWeight: FontWeight.w700),
          ),
        ],
      );
  Widget coursePhoto(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            onTap: () {
              navigateAndPush(context, ViewPhoto(course.logo));
            },
            child: Hero(
              tag: course.id,
              child: Image.network(course.logo,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                        height: 130,
                        color: ColorManager.lightGrey,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                          color: ColorManager.darkGrey,
                        ),
                      )),
            ),
          ),
        ),
      );
}
