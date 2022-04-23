import 'package:auto_id/model/module/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../bloc/student_bloc/student_data_bloc.dart';
import '../../../../model/module/students.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/widgets/form_field.dart';
import '../../admin_view/add_group/add_group.dart';
import '../../admin_view/add_group/widgets/numeric_field.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  final Course course;

  RegisterScreen(this.course, {Key? key}) : super(key: key);
  final List fieldsController = [
    TextEditingController(text: StudentDataBloc.student.name),
    ...List.generate(10, (index) => TextEditingController()),
    TextEditingController(text: "20")
  ];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Gender gender = Gender.male;

  late final List<Widget> fields = [
    Container(),
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
    genderField(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 26,
                      color: ColorManager.mainBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 55),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: course.columns.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) =>
                        Visibility(
                      visible: course.columns[index],
                      child: fields[index],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocConsumer<StudentDataBloc, StudentDataStates>(
                  listenWhen: (_, state) => state is RegisterUserState,
                  buildWhen: (_, state) => state is RegisterUserState,
                  listener: (context, state) => {
                    if (state.status == StudentDataStatus.loaded)
                      Navigator.of(context).pop()
                  },
                  builder: (context, state) => ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ColorManager.mainBlue),
                          foregroundColor: MaterialStateProperty.all(
                              ColorManager.whiteColor)),
                      child: state.status == StudentDataStatus.loaded
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Done",
                              style: TextStyle(fontSize: 18),
                            ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print(generateMap());
                          context.read<StudentDataBloc>().add(
                              RegisterStudentEvent(generateMap(), course.id));
                        }
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget nameField() => DefaultFormField(
        controller: fieldsController[1],
        title: "Name",
        prefix: Icons.person,
        fillHint: AutofillHints.name,
        border: true,
        validator: (val) => val!.isEmpty ? "Name cannot be empty" : null,
      );

  Widget genderField() => StatefulBuilder(
      builder: (_, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio<Gender>(
                    value: Gender.male,
                    groupValue: gender,
                    activeColor: ColorManager.mainBlue,
                    onChanged: (value) {
                      setState(() {
                        gender = value ?? Gender.male;
                      });
                    },
                  ),
                  const Text('Male'),
                ],
              ),
              Row(
                children: [
                  Radio<Gender>(
                    value: Gender.female,
                    groupValue: gender,
                    activeColor: Colors.pinkAccent,
                    onChanged: (value) {
                      setState(() {
                        gender = value ?? Gender.female;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              )
            ],
          ));

  Widget ageField() => Row(
        children: [
          const Text(
            "Age",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorManager.darkGrey),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(child: NumericField(fieldsController[2]))
        ],
      );

  Widget collegeField() => DefaultFormField(
        controller: fieldsController[3],
        title: "College",
        prefix: FontAwesomeIcons.book,
        border: true,
        validator: (val) => val!.isEmpty ? "College cannot be empty" : null,
      );

  Widget departmentField() => DefaultFormField(
        controller: fieldsController[4],
        title: "department",
        prefix: FontAwesomeIcons.pen,
        border: true,
        validator: (val) => val!.isEmpty ? "department cannot be empty" : null,
      );

  Widget imageField() => DefaultFormField(
        controller: fieldsController[5],
        title: "Image Drive Link",
        prefix: FontAwesomeIcons.image,
        keyboardType: TextInputType.url,
        border: true,
        validator: (val) {
          if (val!.isEmpty) {
            return "Image cannot be Empty";
          } else if (!val.contains("drive")) {
            return "Invalid drive link";
          } else {
            return null;
          }
        },
      );

  Widget cvField() => DefaultFormField(
        controller: fieldsController[6],
        title: "CV Drive Link",
        prefix: FontAwesomeIcons.paperclip,
        keyboardType: TextInputType.url,
        border: true,
        validator: (val) {
          if (val!.isEmpty) {
            return "CV cannot be Empty";
          } else if (!val.contains("drive")) {
            return "Invalid drive link";
          } else {
            return null;
          }
        },
      );

  Widget phoneField() => DefaultFormField(
      controller: fieldsController[7],
      title: "Phone Number",
      keyboardType: TextInputType.phone,
      fillHint: AutofillHints.telephoneNumber,
      prefix: FontAwesomeIcons.phone,
      border: true,
      validator: (val) => val!.isEmpty ? "Phone cannot be Empty" : null);

  Widget secondPhoneField() => DefaultFormField(
      controller: fieldsController[8],
      title: "Second phone number",
      fillHint: AutofillHints.telephoneNumber,
      keyboardType: TextInputType.phone,
      prefix: FontAwesomeIcons.squarePhone,
      border: true,
      validator: (val) => val!.isEmpty ? "Second phone cannot be Empty" : null);

  Widget emailField() => DefaultFormField(
      controller: fieldsController[9],
      title: "Email address",
      keyboardType: TextInputType.emailAddress,
      fillHint: AutofillHints.email,
      prefix: Icons.email_outlined,
      border: true,
      validator: (val) => val!.isEmpty ? "Second phone cannot be Empty" : null);

  Widget linkedInField() => DefaultFormField(
      controller: fieldsController[10],
      title: "LinkedIn profile",
      keyboardType: TextInputType.url,
      prefix: FontAwesomeIcons.linkedinIn,
      border: true,
      validator: (val) => val!.isEmpty ? "LinkedIn cannot be Empty" : null);

  Widget facebookField() => DefaultFormField(
      controller: fieldsController[11],
      title: "Facebook profile",
      keyboardType: TextInputType.url,
      prefix: FontAwesomeIcons.facebook,
      border: true,
      validator: (val) => val!.isEmpty ? "Facebook cannot be Empty" : null);

  Widget addressField() => DefaultFormField(
      controller: fieldsController[12],
      title: "Address",
      keyboardType: TextInputType.streetAddress,
      fillHint: AutofillHints.fullStreetAddress,
      prefix: Icons.home,
      border: true,
      validator: (val) => val!.isEmpty ? "Address cannot be Empty" : null);

  Map<String, dynamic> generateMap() {
    Map<String, dynamic> data = {};
    data['ID'] = StudentDataBloc.student.id;
    for (int i = 1; i < columnsNames.length - 1; i++) {
      if (course.columns[i]) {
        data[columnsNames[i]] = fieldsController[i - 1].text;
      }
    }
    if (course.columns.last) {
      data['Gender'] = gender;
    }
    return data;
  }
}
