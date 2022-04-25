import 'package:auto_id/model/module/students.dart';

import 'package:auto_id/view/resources/color_manager.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
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
                          student.rfId ?? "User Information",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorManager.mainBlue,
                              fontSize: 18),
                        ),
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
                                    content:
                                        "Are you sure you want to delete user ",
                                    yesFunction: () {
                                  context.read<AdminDataBloc>().add(
                                      DeleteStudentIndex(
                                          groupIndex, userIndex));
                                });
                              },
                              icon:
                                  const Icon(Icons.restore_from_trash_outlined),
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
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: ColorManager.mainBlue,
                    child: userPhoto(),
                  ),
                  ...List.generate(student.getProps.length,
                      (i) => isHide(student.getProps[i] == null, fields[i])),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorManager.mainBlue),
                        foregroundColor:
                            MaterialStateProperty.all(ColorManager.whiteColor)),
                    child: const Text(
                      "Edit Student",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Course course = context
                          .read<AdminDataBloc>()
                          .state
                          .groupList[groupIndex];
                      navigateAndPush(
                          context,
                          RegisterScreen(
                              course, student, groupIndex, userIndex));
                    }),
              ),
            ),
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
        fadeInDuration: const Duration(milliseconds: 100),
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
            fit: BoxFit.fill,
          );
        },
        image: url,
      ),
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