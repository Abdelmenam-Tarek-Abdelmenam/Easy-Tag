import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:flutter/material.dart';

import '../../../../../model/module/students.dart';
import '../../user_screen/user_screen.dart';

class GroupItemBuilder extends StatelessWidget {
  final int userIndex;
  final int groupIndex;
  final Student student;
  const GroupItemBuilder(this.userIndex, this.groupIndex, this.student,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorManager.darkWhite,
      ),
      child: InkWell(
        onTap: () {
          navigateAndPush(
              context,
              UserScreen(
                student: student,
                groupIndex: groupIndex,
                userIndex: userIndex,
              ));
          // cubit.goToUser(groupIndex, index, context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(8)),
                color: ColorManager.mainBlue,
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                userIndex < 9 ? '0${userIndex + 1}' : '${userIndex + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  student.name,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
