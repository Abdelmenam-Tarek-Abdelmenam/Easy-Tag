import 'package:auto_id/model/module/course.dart';
import 'package:flutter/material.dart';

import '../../../../resources/color_manager.dart';

class DetailsLayout extends StatelessWidget {
  final Course course;
  const DetailsLayout(this.course, {Key? key}) : super(key: key);

  //   late List<String> instructors;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Text(
              "${course.price} EGP - ",
              style: const TextStyle(
                  fontSize: 20,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              course.offer,
              style: const TextStyle(
                  fontSize: 16,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      coursePhoto(context),
      const Text(
        "Description",
        style: TextStyle(
            fontSize: 20,
            color: ColorManager.darkGrey,
            fontWeight: FontWeight.w600),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(course.description),
      const Divider(),
      detailsList(),
      const Divider(),
      Visibility(
          visible: course.instructors.isNotEmpty, child: instructorsList()),
    ]);
  }

  Widget instructorsList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Instructors",
            style: TextStyle(
                fontSize: 20,
                color: ColorManager.darkGrey,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(
                          height: 2,
                        ),
                    itemBuilder: (_, index) =>
                        Text("${index + 1} - ${course.instructors[index]}"),
                    itemCount: course.instructors.length),
              )
            ],
          )
        ],
      );

  Widget detailsList() => Column(
        children: [
          Row(
            children: [
              const Text(
                "Category : ",
                style: TextStyle(
                    fontSize: 18,
                    color: ColorManager.darkGrey,
                    fontWeight: FontWeight.w600),
              ),
              Text("${course.category} - ${course.inPlace} ")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Start Date : ",
                style: TextStyle(
                    fontSize: 18,
                    color: ColorManager.darkGrey,
                    fontWeight: FontWeight.w600),
              ),
              Text(course.date)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Number of sessions : ",
                style: TextStyle(
                    fontSize: 18,
                    color: ColorManager.darkGrey,
                    fontWeight: FontWeight.w600),
              ),
              Text(course.numberOfSessions.toString())
            ],
          )
        ],
      );

  Widget coursePhoto(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.mainBlue, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(course.logo,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
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
