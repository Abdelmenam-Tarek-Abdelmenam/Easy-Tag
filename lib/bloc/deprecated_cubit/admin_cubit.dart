import 'dart:async';
import 'dart:convert';
import 'package:auto_id/model/module/group_details.dart';
import '../../model/module/card_student.dart';
import 'package:auto_id/model/repository/realtime_firebase.dart';

import '../../model/module/app_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../view/shared/functions/navigation_functions.dart';
import '../../view/shared/widgets/toast_helper.dart';
import '../../view/ui/user_screen.dart';
import '../../view/ui/add_group.dart';
import '../../view/ui/edit_user.dart';
import '../../view/ui/main_view/main_screen.dart';
import 'admin_states.dart';

//TODO : This file will be removed nor for copy only

class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(AppInitial());
  static AdminCubit get(context) => BlocProvider.of(context);

  AppAdmin appAdmin = AppAdmin.empty;
  final AdminDataRepository _adminDataRepository = AdminDataRepository();
  CardStudent cardStudent = CardStudent.empty;
  List<GroupDetails>? groups;
  Map<String, dynamic> showedUserData = {};

  /// ************************************************************/
  List<DataColumn> tableNameColumns = [];
  List<DataRow> tableNameRows = [];
  int tableNumberOfUnnamedColumns = 0;
  List<String> renameRowsName = [];

  /// done deleteStudentFromSheet
  void deleteUser(int userIndex, int groupIndex, BuildContext context) {
    emit(DeletePersonLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxx3WO2ZZQ0jSInhHwsl6p3ZvnM4NAVP-ka0ecbqkZJRnOlj8G7qTyvZcZdknsQGvk/exec?fun=remove&group=$groupIndex&person_id=$userIndex&userName=${appAdmin.id}");
    http.read(url).then((value) {
      emit(DeletePersonDone());
      navigateAndReplace(context, MainScreen());
    }).catchError((onError) {
      showToast("Error at deleting");
      emit(DeletePersonError());
    });
  }

  /// done sendStudentNewData
  void sendEditData(
      int groupIndex, String id, Map dataToSent, BuildContext context) {
    emit(SendToEditLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxx3WO2ZZQ0jSInhHwsl6p3ZvnM4NAVP-ka0ecbqkZJRnOlj8G7qTyvZcZdknsQGvk/exec?fun=edit"
        "&group=$groupIndex"
        "&user_data=$dataToSent"
        "&person_id=$id"
        "&userName=${appAdmin.id}");
    http.read(url).then((value) {
      if (cardStudent.state == StudentState.newStudent &&
          cardStudent.id == id) {
        cardStudent = cardStudent.copyWith(
            name: dataToSent['Name'],
            groupIndex: groupIndex,
            state: StudentState.notRegistered);
        _adminDataRepository.updateCardState();
      }
      navigateAndReplace(context, MainScreen());
    }).catchError((err) {
      emit(SendToEditError());
    });
  }

  /// done getUserData
  void goToUser(int groupIndex, int userIndex, BuildContext context) {
    showedUserData = {};
    emit(GetGroupPersonLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?"
        "userName=${appAdmin.id}"
        "&group=$groupIndex"
        "&index=${userIndex + 1}");
    http.read(url).catchError((err) {
      emit(GetGroupPersonError());
    }).then((value) {
      if (!value.startsWith('<!DOCTYPE')) {
        value = '{"$value"}';
        value = value.replaceAll(',', '","');
        value = value.replaceAll('https":"', "https:");
        value = value.replaceAll('http":"', "http:");
        showedUserData = json.decode(value);
      }
      showedUserData['userImageUrl'] = "";
      for (var v in showedUserData.values) {
        if (v.contains('drive.google.com')) {
          if (v.contains('id')) {
            showedUserData['userImageUrl'] = v.toString();
          } else {
            try {
              showedUserData['userImageUrl'] =
                  "https://drive.google.com/uc?export=view&id=" +
                      v.split('/')[5];
              // ignore: empty_catches
            } catch (err) {}
          }
        }
      }
      navigateAndPush(context, UserScreen(userIndex, groupIndex));
      emit(GetGroupPersonDone());
    });
  }

  /// done getUserData
  void getUserData(int groupIndex, int userIndex) {
    showedUserData = {};
    emit(GetGroupPersonLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?"
        "userName=${appAdmin.id}"
        "&group=$groupIndex"
        "&index=${userIndex + 1}");
    http.read(url).catchError((err) {
      emit(GetGroupPersonError());
    }).then((value) {
      if (!value.startsWith('<!DOCTYPE')) {
        value = '{"$value"}';
        value = value.replaceAll(',', '","');
        value = value.replaceAll('https":"', "https:");
        value = value.replaceAll('http":"', "http:");
        showedUserData = json.decode(value);
      }
      emit(GetGroupPersonDone());
    });
  }

  /// done getGroupData
  void goToEditUser(int index, BuildContext context) {
    emit(GoToEditUserLoading());
    if (groups?[index].columnNames == null) {
      var url = Uri.parse(
          "https://script.google.com/macros/s/AKfycbwCgPd0uvbcYCrn3D5v-4GsH_E9OhMUakXe2D3tY0phqN3nxivfWn3efJ4TE6ckqgXa/exec?"
          "userName=${appAdmin.id}"
          "&group=$index");
      http.read(url).then((value) {
        if (!value.startsWith('<!DOCTYPE')) {
          var list = value.split("!");
          groups![index].studentNames = list[0].split(',');
          groups![index].columnNames = list[1].split(',');
        }
        navigateAndPush(
            context, EditUserScreen(cardStudent.id ?? "", index, false));
        emit(GoToEditUserDone());
      }).catchError((onError) {
        emit(GoToEditUserError());
      });
    } else {
      navigateAndPush(
          context, EditUserScreen(cardStudent.id ?? "", index, false));
      emit(GetGroupNamesDone());
    }
  }

  /// done addColumnNames
  void addColumnNames(String id, String groupName, BuildContext context) {
    // run the script to make a column with the id
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbyDVddZV5IbMoj93yxZKY7tPdcyxG7pqjq5wkNTOxPHAKUsLZdvZoWZsjfmCJbhhO6NHA/exec?id=" +
            id +
            "&list=$renameRowsName");
    http.read(url).catchError((err) {}).then((value) {
      if (value.trim() == '1') {
        createGroup(id, groupName, context);
      }
    });
  }

  /// done createSpreadSheet
  Future<String> createSpreadSheet(String groupName, BuildContext context) {
    emit(CreateSpreadSheetLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbz3o9eqSWAGqFUf1C2Vk1waU6DgaqyVUjPtSyz9rw8ZQ-o_8U_aAwnnCaunX1Heo3Vn/exec?name=" +
            appAdmin.id +
            " " +
            groupName);
    return http.read(url);
  }

  // void addRowName(String value, int currentColumnToFill, BuildContext context) {
  //   if (currentColumnToFill - 64 <= tableNumberOfUnnamedColumns) {
  //     renameRowsName.add(value.replaceAll(" ", "-"));
  //     currentColumnToFill++;
  //     emit(ColumnPlusOne());
  //   } else {
  //     showToast("You name all column click the create button",
  //         type: ToastType.info);
  //   }
  // }

  // /// done testSheetLink
  // void testLink(BuildContext context, String groupName, String link) {
  //   emit(TestLinkLoading());
  //   emit(CreateSpreadSheetLoading());
  //   String id = link.split('/')[5];
  //   var url = Uri.parse(
  //       "https://script.google.com/macros/s/AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?id=" +
  //           id);
  //   http.read(url).catchError((err) {
  //     showToast("Error happened while reading the data please try again");
  //     emit(TestLinkError());
  //   }).then((value) {
  //     if (value.trim() == '-1') {
  //       showToast(
  //         "Invalid sheet please make sure that the url is public and editor",
  //       );
  //       emit(TestLinkError());
  //     } else {
  //       // Link Is Ok
  //       createGroup(id, groupName, context);
  //       emit(TestLinkDone());
  //     }
  //   });
  // }

  /// done testSheetLink
  // void useSheetRowAsNameCheckBox(
  //     BuildContext context, bool useSheetRowAsName, String link) {
  //   emit(UseSheetRowAsNameLoading());
  //   renameRowsName = [];
  //   if (useSheetRowAsName) {
  //     useSheetRowAsName = !useSheetRowAsName;
  //     String id = link.split('/')[5];
  //     var url = Uri.parse(
  //         "https://script.google.com/macros/s/AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?id=" +
  //             id);
  //     http.read(url).catchError((err) {
  //       useSheetRowAsName = !useSheetRowAsName;
  //       showToast("Error happened while reading the data please try again");
  //       emit(UseSheetRowAsNameError());
  //     }).then((value) {
  //       if (value.trim() == '-1') {
  //         useSheetRowAsName = !useSheetRowAsName;
  //         showToast(
  //             "Invalid sheet please make sure that the url is public and editor");
  //         emit(UseSheetRowAsNameError());
  //       } else {
  //         createTable(value);
  //         emit(UseSheetRowAsNameDone());
  //       }
  //     });
  //   } else {
  //     useSheetRowAsName = !useSheetRowAsName;
  //     emit(UseSheetRowAsNameDone());
  //   }
  // }

  void addGroup(BuildContext context) {
    tableNameColumns = [];
    tableNameRows = [];
    tableNumberOfUnnamedColumns = 0;
    renameRowsName = [];
    navigateAndPush(context, AddGroup());
    emit(AddGroupState());
  }

  // void createTable(String value) {
  //   tableNameColumns = [];
  //   tableNameRows = [];
  //   tableNumberOfUnnamedColumns =
  //       int.parse(value.split('}{')[0].split('->')[1]);
  //   List<String> row1 = value
  //       .split('}{')[1]
  //       .split("->")[1]
  //       .split('][')[0]
  //       .replaceAll(' [[', '')
  //       .split(',');
  //   List<String> row2 = value
  //       .split('}{')[1]
  //       .split("->")[1]
  //       .split('][')[1]
  //       .replaceAll(']]}', '')
  //       .split(',');
  //   List<DataCell> dCells1 = [];
  //   List<DataCell> dCells2 = [];
  //
  //   for (var i = 0; i < tableNumberOfUnnamedColumns; i++) {
  //     tableNameColumns.add(
  //       DataColumn(
  //           label: Text(String.fromCharCode(i + 65),
  //               style: const TextStyle(
  //                   fontSize: 18, fontWeight: FontWeight.bold))),
  //     );
  //     dCells1.add(DataCell(Text(row1[i])));
  //     dCells2.add(DataCell(Text(row2[i])));
  //   }
  //   tableNameRows = [DataRow(cells: dCells1), DataRow(cells: dCells2)];
  // }
  //
  ///**********************************************/

  Future<void> createGroup(String id, String name, BuildContext context) async {
    await _adminDataRepository.createGroup(GroupDetails(name: name, id: id));
    navigateAndReplace(context, MainScreen());
  }
}
