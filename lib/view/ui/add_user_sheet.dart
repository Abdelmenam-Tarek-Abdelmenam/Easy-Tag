import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/deprecated_cubit/admin_cubit.dart';
import '../resources/color_manager.dart';

// TODO : replace with dropdown menu in add user screen
class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Adding the user to sheet ',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  color: Colors.orange),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'step 1 : choose the group',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15,
                  color: ColorManager.darkGrey),
            ),
            Expanded(
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: context.read<AdminCubit>().groups?.length ?? 0,
                  itemBuilder: (context, index) {
                    return menuItemBuilder(index, context);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 10,
                    );
                  }),
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }

  Widget menuItemBuilder(int index, BuildContext context) {
    return Center(
      child: TextButton(
          child: Text("${context.read<AdminCubit>().groups?[index].name}",
              style: const TextStyle(color: Colors.orange, fontSize: 12)),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(4)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.orange)))),
          onPressed: () {
            context.read<AdminCubit>().goToEditUser(index + 1, context);
          }),
    );
  }
}
