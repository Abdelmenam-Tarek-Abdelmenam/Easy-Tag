import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/ui/admin_view/group_screen/widgets/item_builder.dart';
import 'package:auto_id/view/ui/admin_view/group_screen/widgets/search_bar.dart';
import 'package:auto_id/view/ui/student_view/details_screen/details_screen.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../shared/functions/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/toast_helper.dart';
import '../../qr/qr_generate.dart';

class GroupScreen extends StatelessWidget {
  final int groupIndex;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GroupScreen(this.groupIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocConsumer<AdminDataBloc, AdminDataStates>(
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
          return Scaffold(
              appBar: appBar(state.groupList[groupIndex].name, actions: [
                IconButton(
                  onPressed: () {
                    navigateAndPush(context,
                        QrGeneratorScreen(state.groupList[groupIndex].id));
                  },
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.blue,
                  ),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    _copyId(state.groupList[groupIndex].id);
                  },
                  icon: const Icon(
                    Icons.link,
                    color: Colors.green,
                  ),
                  iconSize: 30,
                ),
                (state is LoadGroupDataState && state.loadingDelete)
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : IconButton(
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
                        icon: Icon(
                          Icons.delete,
                          color: Colors.deepOrange[400],
                        ),
                        iconSize: 30,
                      ),
              ]),
              backgroundColor: ColorManager.lightBlue,
              floatingActionButton: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorManager.mainBlue)),
                onPressed: () => navigateAndPush(
                    context,
                    DetailsScreen(
                      state.groupList[groupIndex],
                      enableRegister: false,
                    )),
                child: const Text('Group Detail'),
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
                                          FontAwesomeIcons
                                              .personCircleExclamation,
                                          color: Colors.grey,
                                          size: 100,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "No Students",
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
                  )));
        },
      ),
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
