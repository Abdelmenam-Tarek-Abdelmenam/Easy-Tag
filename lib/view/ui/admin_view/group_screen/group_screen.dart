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
          } else if ((state is GetInitialDataState) &&
              state.status == AdminDataStatus.loaded &&
              Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
              bottomNavigationBar: Container(
                color: ColorManager.darkWhite,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () {
                            navigateAndPush(
                                context,
                                DetailsScreen(
                                  state.groupList[groupIndex],
                                  enableRegister: false,
                                ));
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.text_snippet_outlined,
                                color: Colors.cyan,
                                size: 30,
                              ),
                              Text('Detail'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () {
                            navigateAndPush(
                                context,
                                QrGeneratorScreen(
                                    state.groupList[groupIndex].id));
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.qr_code_scanner,
                                color: Colors.blue,
                                size: 30,
                              ),
                              Text('Code'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () {
                            _copyId(state.groupList[groupIndex].id);
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.link,
                                size: 30,
                                color: Colors.green,
                              ),
                              Text('Link'),
                            ],
                          ),
                        ),
                      ),
                      (state is LoadGroupDataState && state.loadingDelete)
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : SizedBox(
                              height: 50,
                              width: 50,
                              child: InkWell(
                                onTap: () {
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
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              appBar: appBar(state.groupList[groupIndex].name),
              backgroundColor: ColorManager.whiteColor,
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
                      SearchBar(state.groupList[groupIndex].students ?? [],
                          groupIndex),
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
