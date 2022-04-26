import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/admin_view/group_screen/widgets/item_builder.dart';
import 'package:auto_id/view/ui/admin_view/group_screen/widgets/search_bar.dart';
import 'package:auto_id/view/ui/student_view/details_screen/details_screen.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../shared/functions/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/toast_helper.dart';

class GroupScreen extends StatelessWidget {
  final int groupIndex;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GroupScreen(this.groupIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDataBloc, AdminDataStates>(
      listenWhen: (prev, next) =>
          (next is LoadGroupDataState) || (next is GetInitialDataState),
      buildWhen: (prev, next) => next is LoadGroupDataState,
      listener: (context, state) {
        if (state is LoadGroupDataState) {
          if (state.status == AdminDataStatus.error) {
            Navigator.of(context).pop();
          }
        } else if (state is GetInitialDataState &&
            state.status == AdminDataStatus.loaded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: ColorManager.lightBlue,
              floatingActionButton: FloatingActionButton(
                onPressed: () => navigateAndPush(
                    context,
                    DetailsScreen(
                      state.groupList[groupIndex],
                      enableRegister: false,
                    )),
                child: const Icon(Icons.remove_red_eye_outlined),
              ),
              body: SmartRefresher(
                  enablePullUp: false,
                  controller: _refreshController,
                  onRefresh: () {
                    context
                        .read<AdminDataBloc>()
                        .add(LoadGroupDataEvent(groupIndex, true));
                    _refreshController.refreshCompleted();
                  },
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back_rounded),
                                iconSize: 30,
                              ),
                            ),
                            Text(
                              state.groupList[groupIndex].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.mainBlue,
                                  fontSize: 18),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _copyId(state.groupList[groupIndex].id);
                                  },
                                  icon: const Icon(Icons.link),
                                  iconSize: 30,
                                ),
                                if ((state is LoadGroupDataState) &&
                                    state.loadingDelete)
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                else
                                  IconButton(
                                    onPressed: () {
                                      customChoiceDialog(context,
                                          title: "Warning",
                                          content:
                                              "Are you sure you want to delete The group ",
                                          yesFunction: () {
                                        context
                                            .read<AdminDataBloc>()
                                            .add(DeleteGroupIndex(groupIndex));
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.restore_from_trash_outlined),
                                    iconSize: 30,
                                  )
                              ],
                            )
                          ]),
                      const SizedBox(height: 10),
                      SearchBar(state.groupList[groupIndex].getStudentsNames),
                      Container(
                          padding: const EdgeInsets.all(15),
                          child: (state is LoadGroupDataState) &&
                                  (state.status == AdminDataStatus.loading)
                              ? const Center(child: CircularProgressIndicator())
                              : state.groupList[groupIndex].students!.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.notes,
                                          color: Colors.grey,
                                          size: 100,
                                        ),
                                        Text(
                                          "No students",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    )
                                  : ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: state
                                          .groupList[groupIndex].studentLength,
                                      itemBuilder: (context, userIndex) {
                                        return GroupItemBuilder(
                                            userIndex,
                                            groupIndex,
                                            state.groupList[groupIndex]
                                                .students![userIndex]);
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      }))
                    ],
                  ))),
        );
      },
    );
  }

  void _copyId(String id) {
    Clipboard.setData(ClipboardData(
        text: "https://docs.google.com/spreadsheets/d/" +
            id +
            "/edit?usp=sharing"));
    showToast("The sheet Link copied to clipboard", type: ToastType.success);
  }
}
