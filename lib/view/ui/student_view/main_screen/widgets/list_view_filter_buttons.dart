import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/color_manager.dart';

const List<String> categories = [
  'ALL',
  'Courses',
  'Internships',
  'Events',
  'Competitions'
];

class CategoryButtonsList extends StatelessWidget {
  const CategoryButtonsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return BlocBuilder<StudentDataBloc, StudentDataStates>(
            builder: (_, StudentDataStates state) => CategoryButton(
                category: categories[index],
                isSelected: categories[index] == state.category,
                onPressed: () {
                  if (index == 0 && categories[index] != state.category) {
                    // context
                    //     .read<StudentDataBloc>()
                    //     .add();
                  } else if (categories[index] != "All") {
                    // context
                    //     .read<StudentDataBloc>()
                    //     .add();
                  }
                }),
          );
        },
      ),
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
    return Container(
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? ColorManager.mainOrange : ColorManager.darkGrey,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            category,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
