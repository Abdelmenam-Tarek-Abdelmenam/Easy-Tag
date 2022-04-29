import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/color_manager.dart';

const List<String> categories = [
  'ALL',
  'Course',
  'Internship',
  'Event',
  'Competition',
  'Workshop'
];

class CategoryButtonsList extends StatelessWidget {
  const CategoryButtonsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> filterTitles = List<Widget>.generate(categories.length, (int index) =>
        BlocBuilder<StudentDataBloc, StudentDataStates>(
      builder: (_, StudentDataStates state) => CategoryButton(
          category: categories[index],
          isSelected: categories[index] == state.category,
          onPressed: () {
            context.read<StudentDataBloc>().add(ChangeFilterTypeEvent(categories[index]));
          }),
    ));

    return Column(
      children: [
        Row(
          children: const [
            Icon(Icons.filter_alt_rounded,color: ColorManager.blackColor,),
            Text('Filter',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),

const SizedBox(height: 5,),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            runSpacing: 0,
            spacing: 0,
            alignment: WrapAlignment.start,
            children: filterTitles
          ),
        ),

        // SizedBox(
        //   height: 70,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: categories.length,
        //     physics: const BouncingScrollPhysics(),
        //     itemBuilder: (BuildContext context, int index) {
        //       return BlocBuilder<StudentDataBloc, StudentDataStates>(
        //         builder: (_, StudentDataStates state) => CategoryButton(
        //             category: categories[index],
        //             isSelected: categories[index] == state.category,
        //             onPressed: () {
        //               context
        //                   .read<StudentDataBloc>()
        //                   .add(ChangeFilterTypeEvent(categories[index]));
        //             }),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function() onPressed;

  const CategoryButton({
    Key? key,
    this.category = "All",
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: onPressed,
        child: Container(
            //margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isSelected ? ColorManager.mainBlue : ColorManager.whiteColor,
            ),
            child: Text(
              category,
              textAlign: TextAlign.center,
              style:  TextStyle(
                  fontSize: 14, color: isSelected ? ColorManager.whiteColor: ColorManager.mainBlue  , fontWeight: FontWeight.bold),
            )
        ),
      ),
    );
  }
}
