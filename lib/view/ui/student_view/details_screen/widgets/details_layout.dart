import 'package:auto_id/model/module/course.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../resources/color_manager.dart';

class DetailsLayout extends StatelessWidget {
  final Course course;
  const DetailsLayout(this.course, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
        coursePhoto(context),
            const SizedBox(height: 20,),
            Column(
              children: [
                {'title': 'Course','val':course.name},
                {'title': 'Price', 'val': "${course.price} EGP"},
                {'title': 'Offer', 'val': course.offer},
                {'title': 'Description','val':course.description},
                {'title': 'Category','val':"${course.category} - ${course.inPlace} "},
                {'title': 'Start Date','val':course.date},
                {'title': 'Number of sessions','val':course.numberOfSessions.toString()},
              ].map((e) => Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Text(
                                  '${e['title']} : ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: ColorManager.mainBlue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  e['val']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      )
              ).toList(),
            ),
        Visibility(
            visible: course.instructors.isNotEmpty, child: instructorsList()),
      ]),
    );
  }

  Widget instructorsList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                const Text(
                  'Instructors : ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      color: ColorManager.mainBlue,
                      fontWeight: FontWeight.bold),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 2,
                    ),
                    itemBuilder: (_, index) =>
                        Text(" ${course.instructors[index]}", style: const TextStyle(
                          fontSize: 20,
                          color: ColorManager.darkGrey,),),
                    itemCount: course.instructors.length)
              ],
            ),
          ),
        ],
      );

  Widget coursePhoto(BuildContext context) => Container(
        // height: 180,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.mainBlue, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(course.logo,
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
