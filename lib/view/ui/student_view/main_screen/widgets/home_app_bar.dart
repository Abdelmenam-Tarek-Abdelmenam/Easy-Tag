import 'package:flutter/material.dart';

import '../../../../shared/functions/navigation_functions.dart';
import '../../student_screen/student_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchBar()),
          const SizedBox(
            width: 10,
          ),
          ProfileIcon(
            profileHandler: () {
              navigateAndPush(context, const StudentScreen());
            },
          ),
        ],
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final Function() profileHandler;

  const ProfileIcon({
    Key? key,
    required this.profileHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 20,
      child: IconButton(
        iconSize: 20,
        color: Colors.white,
        icon: const Icon(
          Icons.person_outline_rounded,
          color: Colors.black,
        ),
        onPressed: profileHandler,
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: true,
      onChanged: (value) {
        // context.read<DataStatusBloc>().add(SearchByName(value));
      },
      decoration: const InputDecoration(
        constraints: BoxConstraints(maxHeight: 70, maxWidth: 305),
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(12, 2, 10, 10),
        fillColor: Colors.white,
        hintText: 'Search for the course here ',
        hintStyle: TextStyle(fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
