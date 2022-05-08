import 'package:auto_id/model/module/group_details.dart';
import 'package:auto_id/model/module/students.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:auto_id/view/ui/admin_view/add_rfid/widgets/serach_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../shared/widgets/app_bar.dart';

// ignore: must_be_immutable
class AddUserIdScreen extends StatefulWidget {
  final String id;

  const AddUserIdScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<AddUserIdScreen> createState() => _AddUserIdScreenState();
}

class _AddUserIdScreenState extends State<AddUserIdScreen> {
  String? studentId;
  String? groupId;
  late AdminDataStates state = context.read<AdminDataBloc>().state;
  late List<GroupDetails> groups = state.allGroupList;
  late List<Student> students = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          height: 50,
          child: BlocConsumer<AdminDataBloc, AdminDataStates>(
            listenWhen: (_, state) => state is EditUserState,
            buildWhen: (_, state) => state is EditUserState,
            listener: (context, state) => {
              if (state is EditUserState &&
                  (state.status == AdminDataStatus.loaded))
                Navigator.of(context).pop()
            },
            builder: (context, state) => ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorManager.mainBlue),
                    foregroundColor:
                        MaterialStateProperty.all(ColorManager.whiteColor)),
                child: state.status == AdminDataStatus.loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "ADD RFID",
                        style: TextStyle(fontSize: 18),
                      ),
                onPressed: () {
                  if (studentId != null && groupId != null) {
                    context.read<AdminDataBloc>().add(AddRfIdEvent(
                        {"RFID": widget.id},
                        groupId!,
                        studentId!,
                        students
                            .firstWhere((element) => element.id == studentId)
                            .name));
                  }
                }),
          ),
        ),
        appBar: appBar(widget.id),
        backgroundColor: ColorManager.whiteColor,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar((subName) {
                setState(() {
                  groups = state.allGroupList
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(subName!.toLowerCase()))
                      .toList();
                });
              }, "Course"),
              chooseGroupList(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              SearchBar((subName) {
                setState(() {
                  students = (groups
                              .firstWhere((element) => element.id == groupId)
                              .students ??
                          [])
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(subName!.toLowerCase()))
                      .toList();
                });
              }, "Student"),
              studentsWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseGroupList() => groups.isEmpty
      ? const Center(
          child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "No Groups",
            style: TextStyle(
                color: ColorManager.lightGrey, fontWeight: FontWeight.bold),
          ),
        ))
      : Wrap(
          children: List.generate(
              groups.length,
              (index) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FilterChip(
                      selected: (groupId ?? "") == groups[index].id,
                      label: Text(
                        groups[index].name,
                      ),
                      backgroundColor: Colors.transparent,
                      shape: const StadiumBorder(side: BorderSide()),
                      onSelected: (bool value) {
                        setState(() {
                          groupId = groups[index].id;
                          if (groups[index].students == null) {
                            context
                                .read<AdminDataBloc>()
                                .add(LoadGroupDataEvent(index, false));
                          } else {
                            students = groups[index].students ?? [];
                          }
                        });
                      },
                    ),
                  )));

  Widget studentsWidgets() => BlocConsumer<AdminDataBloc, AdminDataStates>(
        listenWhen: (prev, next) => (next is LoadGroupDataState),
        buildWhen: (prev, next) => next is LoadGroupDataState,
        listener: (context, state) {
          if (state.status == AdminDataStatus.error) {
            showToast("Error Happened");
            students = [];
          } else if (state.status == AdminDataStatus.loaded) {
            groups = state.allGroupList;
            students = groups
                    .firstWhere((element) => element.id == groupId)
                    .students ??
                [];
          }
        },
        builder: (context, state) {
          return state.status == AdminDataStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : chooseStudentList();
        },
      );

  Widget chooseStudentList() => students.isEmpty
      ? const Center(
          child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "No Student",
            style: TextStyle(
                color: ColorManager.lightGrey, fontWeight: FontWeight.bold),
          ),
        ))
      : Wrap(
          children: List.generate(
              students.length,
              (index) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FilterChip(
                      selected: (studentId ?? "") == students[index].id,
                      label: Text(
                        students[index].name,
                      ),
                      backgroundColor: Colors.transparent,
                      shape: const StadiumBorder(side: BorderSide()),
                      onSelected: (bool value) {
                        setState(() {
                          studentId = students[index].id;
                        });
                      },
                    ),
                  )));
}
