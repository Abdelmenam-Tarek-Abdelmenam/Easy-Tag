import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/widgets/form_field.dart';

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
  "Address"
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

                    for (int i = 0; i < 11; i++) {
                      if (neededColumns[i]) {
                        renameRowsName.add(neededColumnsNames[i]);
                      }
                    }
                    // cubit
                    //     .createSpreadSheet(sheetNameController.text, context)
                    //     .then((value) {
                    //   cubit.addColumnNames(
                    //       value, sheetNameController.text, context);
                    // });
                  }
                  // } else {
                  //   if (formKey.currentState!.validate()) {
                  //     if (useSheetRowAsName) {
                  //       cubit.testLink(context, sheetNameController.text,
                  //           sheetLinkController.text);
                  // } else {
                  //   if (renameRowsName.length ==
                  //       cubit.tableNumberOfUnnamedColumns) {
                  //     cubit.addColumnNames(
                  //         sheetLinkController.text.split('/')[5],
                  //         sheetNameController.text,
                  //         context);
                  //   } else {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           Future.delayed(const Duration(seconds: 4), () {
                  //             Navigator.of(context).pop(true);
                  //           });
                  //           return const AlertDialog(
                  //             title: Text("make sure you name all columns"),
                  //             backgroundColor: Colors.red,
                  //           );
                  //         });
                  //   }
                  //     }
                  //   }
                  // }
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
                    const Center(
                      child: Text(
                        'Create new Sheet',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: formKey,
                        child: DefaultFormField(
                            controller: sheetNameController,
                            title: "Group name",
                            prefix: Icons.drive_file_rename_outline)),
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
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget chooseColumnName() {
    // FilterChip(
    //   label: Text("text"),
    //   backgroundColor: Colors.transparent,
    //   shape: StadiumBorder(side: BorderSide()),
    //   onSelected: (bool value) {print("selected");},
    // );
    return Column(
        children: List.generate(
            neededColumnsNames.length,
            (index) => StatefulBuilder(
                  builder: (_, setState) {
                    return CheckboxListTile(
                        title: Text(
                          neededColumnsNames[index],
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        value: neededColumns[9],
                        onChanged: (newValue) {
                          setState(() {
                            neededColumns[9] = !neededColumns[9];
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                        contentPadding: const EdgeInsets.all(0.0));
                  },
                )));
  }

  // Widget addFromExistingSheet() {
  //   return Padding(
  //     padding: const EdgeInsets.all(15.0),
  //     child: Center(
  //       child: SingleChildScrollView(
  //         reverse: true,
  //         child: Column(
  //           children: [
  //             Form(
  //                 key: formKey,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       'If you already have sheet',
  //                       style: TextStyle(
  //                           fontSize: 25,
  //                           color: Colors.orange,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     const Padding(
  //                       padding: EdgeInsets.symmetric(vertical: 8.0),
  //                       child: Text(
  //                         'make sure that the link is "Editor" & "For every one" \nThe ID column should named as <ID>\nThe name column should named as <Name>"',
  //                         style: TextStyle(
  //                             color: Colors.red,
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                     TextFormField(
  //                         controller: sheetNameController,
  //                         keyboardType: TextInputType.text,
  //                         validator: (value) {
  //                           if (value!.isEmpty) {
  //                             return 'Name cannot be empty';
  //                           } else {
  //                             return null;
  //                           }
  //                         },
  //                         decoration: InputDecoration(
  //                           labelText: "Group name",
  //                           prefixIcon:
  //                               const Icon(Icons.drive_file_rename_outline),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderSide: const BorderSide(
  //                                 color: Colors.orange, width: 2.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                         )),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     TextFormField(
  //                         controller: sheetLinkController,
  //                         keyboardType: TextInputType.url,
  //                         validator: (value) {
  //                           if (value!.isEmpty) {
  //                             return 'Link cannot be empty';
  //                           } else {
  //                             return null;
  //                           }
  //                         },
  //                         decoration: InputDecoration(
  //                           enabled: useSheetRowAsName,
  //                           labelText: "Sheet Link",
  //                           prefixIcon: const Icon(Icons.link),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderSide: const BorderSide(
  //                                 color: Colors.orange, width: 2.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                         )),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     CheckboxListTile(
  //                         title: const Text(
  //                           "Use the first Row as columns name",
  //                           style: TextStyle(
  //                               color: Colors.black54,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                         value: useSheetRowAsName,
  //                         onChanged: (newValue) {
  //                           if (formKey.currentState!.validate()) {
  //                             cubit.useSheetRowAsNameCheckBox(context,
  //                                 useSheetRowAsName, sheetLinkController.text);
  //                           }
  //                         },
  //                         controlAffinity: ListTileControlAffinity
  //                             .leading, //  <-- leading Checkbox
  //                         contentPadding: const EdgeInsets.all(0.0)),
  //                   ],
  //                 )),
  //             Container(
  //                 child: state is UseSheetRowAsNameLoading
  //                     ? const Center(child: CircularProgressIndicator())
  //                     : useSheetRowAsName == true
  //                         ? Container()
  //                         : Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Padding(
  //                                 padding: EdgeInsets.symmetric(vertical: 8.0),
  //                                 child: Text('specify column name',
  //                                     style: TextStyle(
  //                                         fontSize: 18,
  //                                         fontWeight: FontWeight.bold,
  //                                         color: ColorManager.darkGrey)),
  //                               ),
  //                               Form(
  //                                 key: formKey2,
  //                                 child: TextFormField(
  //                                     controller: columnNameController,
  //                                     keyboardType: TextInputType.text,
  //                                     validator: (value) {
  //                                       if (value!.isEmpty) {
  //                                         return 'column name cannot be empty';
  //                                       } else {
  //                                         return null;
  //                                       }
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       labelText:
  //                                           "Column ${String.fromCharCode(currentColumnToFill)} name",
  //                                       prefixIcon: const Icon(
  //                                           Icons.file_copy_outlined),
  //                                       suffixIcon: IconButton(
  //                                           onPressed: () {
  //                                             if (formKey2.currentState!
  //                                                 .validate()) {
  //                                               cubit.addRowName(
  //                                                   columnNameController.text,
  //                                                   currentColumnToFill,
  //                                                   context);
  //                                             }
  //                                             columnNameController.text = "";
  //                                           },
  //                                           icon: const Icon(
  //                                             Icons.next_plan_outlined,
  //                                             size: 25,
  //                                             color: Colors.orange,
  //                                           )),
  //                                       enabledBorder: OutlineInputBorder(
  //                                         borderSide: const BorderSide(
  //                                             color: ColorManager.darkGrey,
  //                                             width: 2.0),
  //                                         borderRadius:
  //                                             BorderRadius.circular(15.0),
  //                                       ),
  //                                     )),
  //                               ),
  //                               SingleChildScrollView(
  //                                 scrollDirection: Axis.horizontal,
  //                                 child: DataTable(
  //                                   columns: cubit.tableNameColumns,
  //                                   rows: cubit.tableNameRows,
  //                                 ),
  //                               ),
  //                             ],
  //                           )),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
