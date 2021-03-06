import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/model/module/card_student.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import '../../add_rfid/edit_user_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/color_manager.dart';

// ignore: must_be_immutable
class UserCard extends StatelessWidget {
  final CardStudent cardStudent;
  bool loading;
  UserCard(this.cardStudent, this.loading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CupertinoActivityIndicator(
        radius: 20,
      );
    }
    switch (cardStudent.state) {
      case StudentState.empty:
        return CardBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 5,
              ),
              Icon(
                Icons.nfc_rounded,
                color: Colors.black54,
                size: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Scan To Show",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      case StudentState.newStudent:
        return CardBox(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        // name
                        'New User',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ID : ${cardStudent.id}',
                        style: const TextStyle(
                            color: ColorManager.darkGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide(color: Colors.blue))),
                            child: const Text("add new user"),
                            onPressed: () => navigateAndPush(
                                context, AddUserIdScreen(cardStudent.id!))),
                      ),
                    ]),
              ),
            ),
            cardImage(cardStudent.imgUrl),
          ],
        ));
      default:
        return CardBox(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cardStudent.name.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: ColorManager.mainBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Group : ${context.read<AdminDataBloc>().state.allGroupList[cardStudent.groupIndex!].name}'),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('ID : ${cardStudent.id}'),
                      const SizedBox(
                        height: 5,
                      ),
                      cardStudent.state == StudentState.notRegistered
                          ? Wrap(
                              children: const [
                                Text(
                                  'not Registered ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 15,
                                )
                              ],
                            )
                          : Wrap(
                              children: const [
                                Text(
                                  'Process completed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 15,
                                )
                              ],
                            ),
                    ]),
              ),
            ),
            cardImage(cardStudent.imgUrl),
          ],
        ));
    }
  }

  Widget cardImage(String url) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorManager.lightBlue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  url,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (
                    _,
                    __,
                    ___,
                  ) {
                    return Image.asset(
                      'images/avatar.png',
                      width: 100,
                      color: Colors.white,
                    );
                  },
                )),
          ),
        ),
      );
}

class CardBox extends StatelessWidget {
  final Widget child;
  const CardBox({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blue[100],
            border: Border.all(color: ColorManager.mainBlue),
            borderRadius: BorderRadius.circular(10)),
        width: 500,
        // height: 200,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text(
                'Last Scan',
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            child
          ],
        ));
  }
}
