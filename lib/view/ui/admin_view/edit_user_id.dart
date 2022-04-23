import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddUserIdScreen extends StatelessWidget {
  final String id;
  final TextEditingController typeAheadController = TextEditingController();

  AddUserIdScreen(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.check,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {}),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        iconSize: 30,
                      ),
                      Text(
                        id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorManager.mainBlue,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
                TypeAheadField(
                  suggestionsCallback: (pattern) async {
                    List<String> sug = [];

                    return sug;
                  },
                  onSuggestionSelected: (suggestion) {
                    // int userIndex = cubit.groups![groupIndex].studentNames!
                    //     .indexOf(suggestion.toString());
                    // dataHere = true;
                    // typeAheadController.text = suggestion.toString();
                    // // cubit.getUserData(groupIndex, userIndex);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                      leading: const Icon(Icons.assignment_ind_outlined),
                    );
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: typeAheadController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ColorManager.darkGrey, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
