import 'package:auto_id/view/ui/admin_view/main_screen/widgets/group_list.dart';
import 'package:auto_id/view/ui/admin_view/main_screen/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../student_view/main_screen/widgets/home_app_bar.dart';
import '../add_group/add_group.dart';

class MainScreen extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            navigateAndPush(context, const AddGroupScreen());
            // cubit.addGroup(context);
          },
        ),
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
                          const HomeAppBar(),
                          UserCard(
                              (state).cardStudent,
                              myState &&
                                  (state.status == AdminDataStatus.loading)),
                          const SizedBox(
                            height: 20,
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
    );
  }

  Widget emptyGroups() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            FontAwesomeIcons.rightFromBracket,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            "No internet",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      );
}
