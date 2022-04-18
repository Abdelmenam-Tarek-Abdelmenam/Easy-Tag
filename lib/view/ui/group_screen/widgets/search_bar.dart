import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchBar extends StatelessWidget {
  final List<String> names;
  const SearchBar(this.names, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: TypeAheadField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                labelText: 'Search for Student',
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
            return names.where((element) => element.contains(pattern));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {}),
    );
  }
}
