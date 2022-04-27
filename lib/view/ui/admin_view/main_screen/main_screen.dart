import 'package:auto_id/view/shared/widgets/powered_by_navigation_bar.dart';
import 'package:auto_id/view/ui/admin_view/main_screen/widgets/group_list.dart';
import 'package:auto_id/view/ui/admin_view/main_screen/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/dialog.dart';
import '../../start_screen/signing/login_screen.dart';
import '../add_group/add_group.dart';
import '../device_config/esp_config.dart';
import 'widgets/home_app_bar.dart';

class MainScreen extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => dialog(context),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: appBar('EME-IH - admin', actions: [
            //optionsWidget(context),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  navigateAndPush(context, const SendConfigScreen());
                }),
            BlocConsumer<AdminDataBloc, AdminDataStates>(
                buildWhen: (prev, next) => next is SignOutState,
                listenWhen: (prev, next) => next is SignOutState,
                builder: (context, state) => IconButton(
                    icon: (state.status == AdminDataStatus.loaded) &&
                            (state is SignOutState)
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AdminDataBloc>().add(SignOutEvent());
                    }),
                listener: (context, state) {
                  if ((state.status == AdminDataStatus.loading) &&
                      (state is SignOutState)) {
                    navigateAndReplace(context, const LoginView());
                  }
                }),
          ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorManager.mainBlue,
            child: const Icon(
              Icons.add,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              navigateAndPush(context, const AddGroupScreen());
              //cubit.addGroup(context);
            },
          ),
          bottomNavigationBar: poweredBy(),
          body: Container(
            padding: const EdgeInsets.all(10.0),
            child: SmartRefresher(
                enablePullUp: false,
                controller: _refreshController,
                onRefresh: () {
                  context
                      .read<AdminDataBloc>()
                      .add(StartAdminOperations(AdminDataBloc.admin));
                  _refreshController.refreshCompleted();
                },
                child: BlocBuilder<AdminDataBloc, AdminDataStates>(
                    buildWhen: (prev, next) => next is GetInitialDataState,
                    builder: (_, state) {
                      bool myState = state is GetInitialDataState;
                      if (myState && (state.status == AdminDataStatus.error)) {
                        return emptyGroups();
                      } else {
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            UserCard(
                                (state).cardStudent,
                                myState &&
                                    (state.status == AdminDataStatus.loading)),
                            const Divider(height: 40),
                            const HomeAppBar(),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Groups',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GroupList(
                                state.groupList,
                                myState &&
                                    (state.status == AdminDataStatus.loading)),
                          ],
                        );
                      }
                    })),
          ),
        ),
      ),
    );
  }

  Widget emptyGroups() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.wifi_off_rounded,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            "No Internet",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      );
}
