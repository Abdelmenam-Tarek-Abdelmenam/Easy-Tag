import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/widgets/form_field.dart';

List<String> neededColumnsNames = const [
  "ID",
  "Name",
  "Gender",
  "Department",
  "Image",
  "Phone",
  "second-Phone",
  "Email",
  "LinkedIn",
  "Facebook",
  "Address",
];

// ignore: must_be_immutable
class AddGroup extends StatelessWidget {
  AddGroup({Key? key}) : super(key: key);

  List<bool> neededColumns =
      List.generate(neededColumnsNames.length, (index) => index < 2);
  var sheetNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDataBloc, AdminDataStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorManager.darkGrey,
                child: 5 == 6
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                onPressed: () {
                  // if (addIndex == 0) {
                  if (formKey.currentState!.validate()) {
                    List<String> renameRowsName = [];

                    for (int i = 0; i < neededColumns.length; i++) {
                      if (neededColumns[i]) {
                        renameRowsName.add(neededColumnsNames[i]);
                      }
                    }
                    print(renameRowsName);
                    // cubit
                    //     .createSpreadSheet(sheetNameController.text, context)
                    //     .then((value) {
                    //   cubit.addColumnNames(
                    //       value, sheetNameController.text, context);
                    // });
                  }
                },
              ),
              // bottomNavigationBar: CurvedNavigationBar(
              //   backgroundColor: Colors.white,
              //   color: Colors.orange,
              //   items: const [
              //     Icon(
              //       Icons.create_new_folder_outlined,
              //       size: 30,
              //       color: Colors.white,
              //     ),
              //     Icon(
              //       Icons.folder_open_sharp,
              //       size: 30,
              //       color: Colors.white,
              //     ),
              //   ],
              //   onTap: (index) {
              //     //Handle button tap
              //     // addIndex = index;
              //     // cubit.changeAddTab();
              //   },
              // ),
              appBar: AppBar(
                shape: StyLeManager.appBarShape,
                foregroundColor: Colors.white,
                title: const Text('Add Group'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        key: formKey,
                        child: DefaultFormField(
                          controller: sheetNameController,
                          title: "Group name",
                          prefix: Icons.drive_file_rename_outline,
                          validator: (val) =>
                              val!.isEmpty ? "Name cannot be empty" : null,
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'specify your needed columns',
                        style: TextStyle(
                            fontSize: 20,
                            color: ColorManager.darkGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    chooseColumnName(),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget chooseColumnName() {
    return Wrap(
        children: List.generate(
            neededColumnsNames.length,
            (index) => StatefulBuilder(
                  builder: (_, setState) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FilterChip(
                        selected: neededColumns[index],
                        label: Text(
                          neededColumnsNames[index],
                        ),
                        backgroundColor: Colors.transparent,
                        shape: StadiumBorder(side: BorderSide()),
                        onSelected: (bool value) {
                          if (index < 2) return;
                          setState(() {
                            neededColumns[index] = value;
                          });
                        },
                      ),
                    );
                  },
                )));
  }
}
