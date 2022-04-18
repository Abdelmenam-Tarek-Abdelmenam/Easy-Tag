import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';

class GroupItemBuilder extends StatelessWidget {
  final int userIndex;
  final int groupIndex;
  final String name;
  const GroupItemBuilder(this.userIndex, this.groupIndex, this.name, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorManager.lightGrey,
      ),
      child: InkWell(
        onTap: () {
          // cubit.goToUser(groupIndex, index, context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.all(10),
              child: Text(
                userIndex < 9 ? '0${userIndex + 1}' : '${userIndex + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
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
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
