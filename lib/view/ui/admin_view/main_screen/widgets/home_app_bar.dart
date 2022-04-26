import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../../shared/functions/navigation_functions.dart';
import '../../../start_screen/signing/login_screen.dart';
import '../../device_config/esp_config.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.indigo[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(),
        ));
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
        context.read<AdminDataBloc>().add(SearchByNameEvent(value));
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
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
