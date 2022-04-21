import 'package:auto_id/model/module/students.dart';

import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../shared/functions/dialogs.dart';

class UserScreen extends StatelessWidget {
  final int groupIndex;
  final int userIndex;
  final Student student;

  const UserScreen(
      {required this.student,
      required this.userIndex,
      required this.groupIndex,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {}),
        body: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_rounded),
                iconSize: 30,
              ),
              Text(
                student.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.mainBlue,
                    fontSize: 18),
              ),
              BlocConsumer<AdminDataBloc, AdminDataStates>(builder: (_, state) {
                if (state is DeleteUserState &&
                    (state.status == AdminDataStatus.loading)) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      customChoiceDialog(context,
                          title: "Warning",
                          content: "Are you sure you want to delete user ",
                          yesFunction: () {
                        context
                            .read<AdminDataBloc>()
                            .add(DeleteStudentIndex(groupIndex, userIndex));
                      });
                    },
                    icon: const Icon(Icons.restore_from_trash_outlined),
                    iconSize: 30,
                  );
                }
              }, listener: (context, state) {
                if (state is LoadGroupDataState &&
                    (state.status == AdminDataStatus.loaded)) {
                  Navigator.of(context).pop();
                }
              }),
            ]),
          ],
        ),
      ),
    );
  }
}
