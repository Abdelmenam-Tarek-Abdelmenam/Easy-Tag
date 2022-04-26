import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/functions/navigation_functions.dart';
import '../../group_screen/group_screen.dart';

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
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return groupItemBuilder(index, context);
                },),
      );
    }
  }

  Widget groupItemBuilder(int index, BuildContext context) => Padding(
    padding: const EdgeInsets.all(2),
    child: ListTile(
      //textColor: Colors.black,
      horizontalTitleGap: 0,
      leading: Text(
        (index+1).toString(),
        style: const TextStyle(
          //color: ColorManager.lightBlue,
            fontSize: 30,
            fontWeight: FontWeight.w100),
      ),
      subtitle: Text(
        groups[index].date,
        style: const TextStyle(
          //color: ColorManager.lightBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      title: Text(
        groups[index].name,
        style: const TextStyle(
            fontSize: 20,),
      ),
      trailing: Text(
        '${groups[index].students?.length}',
        style: const TextStyle(
            fontSize: 20,),
      ),

      onTap: (){context
          .read<AdminDataBloc>()
          .add(LoadGroupDataEvent(index, false));
      navigateAndPush(context, GroupScreen(index));},
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
