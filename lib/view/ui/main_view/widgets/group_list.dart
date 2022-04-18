import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/color_manager.dart';

class GroupList extends StatelessWidget {
  final List<GroupDetails> groups;
  final bool loading;
  const GroupList(this.groups, this.loading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Container(
        child: groups.isEmpty
            ? emptyGroups()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return groupItemBuilder(index, context);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                }),
      );
    }
  }

  Widget groupItemBuilder(int index, BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorManager.darkGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              context
                  .read<AdminDataBloc>()
                  .add(LoadGroupDataEvent(index, false));
            },
            child: Column(
              children: [
                Text(
                  groups[index].name,
                  style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );

  Widget emptyGroups() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.event_note_sharp,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            "no groups yet",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      );
}
