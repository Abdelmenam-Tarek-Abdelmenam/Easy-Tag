import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({this.count = 12, Key? key}) : super(key: key);
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      // shrinkWrap: true,
      padding: EdgeInsets.only(top: count == 1 ? 20 : 60),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Container(),
        );
      },
    );
  }
}
