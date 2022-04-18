import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/styles_manager.dart';
import 'package:auto_id/view/ui/group_screen/widgets/item_builder.dart';
import 'package:auto_id/view/ui/group_screen/widgets/search_bar.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../shared/functions/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/widgets/toast_helper.dart';

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
          } else if (state.status == AdminDataStatus.loaded &&
              _refreshController.isLoading) {
            _refreshController.refreshCompleted();
          }
        } else if (state is GetInitialDataState &&
            state.status == AdminDataStatus.loaded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    _copyId(state.groupList[groupIndex].id);
                  },
                  icon: const Icon(Icons.link),
                  iconSize: 30,
                ),
                if ((state is LoadGroupDataState) && state.loadingDelete)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
                else
                  IconButton(
                    onPressed: () {
                      customChoiceDialog(context,
                          title: "Warning",
                          content: "Are you sure you want to delete user ",
                          yesFunction: () {
                        context
                            .read<AdminDataBloc>()
                            .add(DeleteGroupIndex(groupIndex));
                      });
                    },
                    icon: const Icon(Icons.restore_from_trash_outlined),
                    iconSize: 30,
                  )
              ],
              foregroundColor: Colors.white,
              shape: StyLeManager.appBarShape,
              title: Text(
                state.groupList[groupIndex].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: SmartRefresher(
                enablePullUp: false,
                controller: _refreshController,
                onRefresh: () {
                  context
                      .read<AdminDataBloc>()
                      .add(LoadGroupDataEvent(groupIndex, true));
                },
                child: Column(
                  children: [
                    //! expanded
                    SearchBar(state.groupList[groupIndex].studentNames ?? []),
                    Container(
                        padding: const EdgeInsets.all(15),
                        child: (state is LoadGroupDataState) &&
                                (state.status == AdminDataStatus.loading)
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                itemCount:
                                    state.groupList[groupIndex].itemsLength,
                                itemBuilder: (context, userIndex) {
                                  return GroupItemBuilder(
                                      userIndex,
                                      groupIndex,
                                      state.groupList[groupIndex]
                                          .studentNames![userIndex]);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                })),
                  ],
                )));
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
