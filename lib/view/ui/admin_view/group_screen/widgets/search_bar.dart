import 'package:auto_id/model/module/students.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../user_screen/user_screen.dart';

class SearchBar extends StatelessWidget {
  final List<Student> names;
  final int groupIndex;
  const SearchBar(this.names, this.groupIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TypeAheadField<Student>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                labelText: 'Search for Student',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderSide: (const BorderSide(color: ColorManager.mainBlue)),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                )),
          ),
          // hideOnError: true,
          suggestionsCallback: (pattern) {
            return names.where(
                (e) => e.name.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(suggestion.name),
            );
          },
          onSuggestionSelected: (suggestion) {
            int index =
                names.indexWhere((element) => element.id == suggestion.id);
            navigateAndPush(
                context,
                UserScreen(
                  student: suggestion,
                  groupIndex: groupIndex,
                  userIndex: index,
                ));
          }),
    );
  }
}
