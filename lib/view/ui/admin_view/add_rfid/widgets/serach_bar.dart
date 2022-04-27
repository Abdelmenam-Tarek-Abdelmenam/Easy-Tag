import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String?) callback;
  final String title;
  const SearchBar(this.callback, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: true,
      onChanged: callback,
      decoration: InputDecoration(
        // constraints: const BoxConstraints(maxHeight: 70, maxWidth: 305),
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(12, 2, 10, 10),
        fillColor: Colors.white,
        hintText: 'Search for the $title ',
        hintStyle: const TextStyle(fontSize: 12),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
