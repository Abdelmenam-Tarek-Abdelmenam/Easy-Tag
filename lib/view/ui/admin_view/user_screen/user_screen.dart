import 'package:auto_id/model/module/students.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/ui/admin_view/user_screen/widgets/field_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../../model/module/course.dart';
import '../../../shared/functions/dialogs.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../student_view/register_screen/register_screen.dart';

// ignore: must_be_immutable
class UserScreen extends StatelessWidget {
  final int groupIndex;
  final int userIndex;
  final Student student;

  UserScreen(
      {required this.student,
      required this.userIndex,
      required this.groupIndex,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(student.image);
    return Scaffold(
      bottomNavigationBar: groupIndex == -1
          ? null
          : ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(200, 55)),
                  backgroundColor:
                      MaterialStateProperty.all(ColorManager.mainBlue),
                  foregroundColor:
                      MaterialStateProperty.all(ColorManager.whiteColor)),
              child: const Text(
                "Edit Student",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Course course =
                    context.read<AdminDataBloc>().state.groupList[groupIndex];
                navigateAndPush(context,
                    RegisterScreen(course, student, groupIndex, userIndex));
              }),
      appBar: appBar(student.rfId ?? "User Information",
          actions: groupIndex == -1
              ? null
              : [
                  BlocConsumer<AdminDataBloc, AdminDataStates>(
                      builder: (_, state) {
                    if (state is DeleteUserState &&
                        (state.status == AdminDataStatus.loading)) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else {
                      return IconButton(
                        onPressed: () {
                          customChoiceDialog(context,
                              title: "Warning",
                              content: "Are you sure you want to delete user ",
                              yesFunction: () {
                            context
                                .read<AdminDataBloc>()
                                .add(DeleteStudentIndex(groupIndex, userIndex));
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.deepOrange[400],
                        ),
                        iconSize: 30,
                      );
                    }
                  }, listener: (context, state) {
                    if (state is LoadGroupDataState &&
                        (state.status == AdminDataStatus.loaded)) {
                      Navigator.of(context).pop();
                    }
                  }),
                ]),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 60,
              foregroundColor: Colors.white,
              backgroundColor: ColorManager.mainBlue,
              child: userPhoto(),
            ),
            const SizedBox(
              height: 20,
            ),
            ...List.generate(student.getProps.length,
                (i) => isHide(student.getProps[i] == null, fields[i])),
            const SizedBox(
              height: 10,
            ),
            attendanceWidget()
          ],
        ),
      ),
    );
  }

  isHide(bool hide, Widget child) => Visibility(visible: !hide, child: child);
  late List<Widget> fields = [
    nameField(),
    ageField(),
    collegeField(),
    departmentField(),
    imageField(),
    cvField(),
    phoneField(),
    secondPhoneField(),
    emailField(),
    linkedInField(),
    facebookField(),
    addressField(),
    genderField()
  ];

  Widget userPhoto({String? url}) {
    url = url ??
        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D";
    return ClipOval(
      child: FadeInImage.assetNetwork(
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 1),
        width: 100,
        placeholder: 'images/avatar.png',
        imageErrorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Image.asset(
            'images/avatar.png',
            width: 100,
            color: Colors.white,
            fit: BoxFit.fill,
          );
        },
        image: url,
      ),
    );
  }

  Widget attendanceWidget() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Registration States',
            style: TextStyle(
                color: ColorManager.mainBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        ...student.attendance.isEmpty
            ? const [
                SizedBox(
                  height: 15,
                ),
                Icon(
                  FontAwesomeIcons.calendar,
                  color: Colors.grey,
                  size: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "No records yet",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              ]
            : [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      student.attendance.keys.toList()[index],
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )),
                                Expanded(
                                  child: Center(
                                    child: student.attendance.values
                                            .toList()[index]
                                            .toString()
                                            .contains(':')
                                        ? const Icon(
                                            Icons.check,
                                            size: 35,
                                            color: Colors.green,
                                          )
                                        : const Text(
                                            'X',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: student.attendance.length),
                  ),
                )
              ]
      ],
    );
  }

  Widget nameField() =>
      FieldDesign(title: "Name", body: student.name, icon: Icons.person);

  Widget genderField() => FieldDesign(
      title: "Gender",
      body: (student.gender ?? Gender.male).name,
      icon: FontAwesomeIcons.genderless);

  Widget ageField() => FieldDesign(
      title: "Age", body: student.age.toString(), icon: Icons.numbers);

  Widget collegeField() => FieldDesign(
      title: "College", body: student.college!, icon: FontAwesomeIcons.school);

  Widget departmentField() => FieldDesign(
      title: "Department",
      body: student.department ?? "",
      icon: FontAwesomeIcons.graduationCap);

  Widget imageField() => Container();

  Widget cvField() => FieldDesign(
      title: "CV", body: student.cV ?? "", icon: FontAwesomeIcons.link);

  Widget phoneField() => FieldDesign(
      title: "Phone", body: student.phone ?? "", icon: FontAwesomeIcons.phone);

  Widget secondPhoneField() => FieldDesign(
      title: "Second Phone",
      body: student.phone2 ?? "",
      icon: FontAwesomeIcons.phone);

  Widget emailField() =>
      FieldDesign(title: "Email", body: student.email ?? "", icon: Icons.email);

  Widget linkedInField() => FieldDesign(
      title: "LinkedIn",
      body: student.linkedIn ?? "",
      icon: FontAwesomeIcons.linkedinIn);

  Widget facebookField() => FieldDesign(
      title: "Facebook",
      body: student.facebook ?? "",
      icon: FontAwesomeIcons.facebook);

  Widget addressField() => FieldDesign(
      title: "Address", body: student.address ?? "", icon: Icons.home);
}
