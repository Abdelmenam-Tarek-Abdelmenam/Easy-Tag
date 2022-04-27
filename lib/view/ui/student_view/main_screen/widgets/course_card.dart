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
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
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
                        color: ColorManager.mainBlue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                                ColorManager.mainBlue),
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
                child: coursePhoto(),
              )
            ],
          ),
        ],
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
              course.offer + " offer",
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
  Widget coursePhoto() => Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.mainBlue, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
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
      );
}
