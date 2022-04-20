import 'package:flutter/material.dart';

import '../../../../resources/color_manager.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({this.count = 12, Key? key}) : super(key: key);
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(
        height: 10,
      ),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: count == 1 ? 20 : 60),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 5),
          height: 200,
          decoration: BoxDecoration(
            color: ColorManager.lightBlue.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(2, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: ColorManager.darkGrey,
                      height: 14,
                    ),
                    Container(
                      color: ColorManager.darkGrey,
                      width: 50,
                      height: 12,
                    ),
                    Container(
                      color: ColorManager.darkGrey,
                      width: 70,
                      height: 10,
                    ),
                    Container(
                      color: ColorManager.darkGrey,
                      height: 8,
                    ),
                    Container(
                      color: ColorManager.darkGrey,
                      width: 80,
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorManager.mainBlue),
                            foregroundColor: MaterialStateProperty.all(
                                ColorManager.whiteColor)),
                        onPressed: () {
                          // navigateAndPush(context, DetailsScreen(course));
                        },
                        child: const Text("See details"))
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorManager.darkGrey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 180,
                      color: ColorManager.lightGrey,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: ColorManager.darkGrey,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
