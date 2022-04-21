import 'dart:io';

import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/shared/widgets/form_field.dart';
import 'package:auto_id/view/ui/admin_view/add_group/models.dart';
import 'package:auto_id/view/ui/admin_view/add_group/widgets/numeric_field.dart';
import 'package:auto_id/view/ui/admin_view/add_group/widgets/view_photo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/toast_helper.dart';

List<String> _columnsNames = const [
  "ID",
  "Name",
  "Age",
  "College",
  "Department",
  "Image",
  "CV",
  "Phone",
  "second-Phone",
  "Email",
  "LinkedIn",
  "Facebook",
  "Address",
  "Gender",
];

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  List<bool> neededColumns =
      List.generate(_columnsNames.length, (index) => index < 2);

  var formKey = GlobalKey<FormState>();
  var sheetName = TextEditingController();
  var maxStudents = TextEditingController(text: "0");
  var numberOfSessions = TextEditingController(text: "1");
  var priceController = TextEditingController(text: "1000");
  TextEditingController description = TextEditingController();
  TextEditingController offer = TextEditingController();
  String category = "Course";
  String inPlace = "in place";
  String? link;
  DateTime startDate = DateTime.now();
  List<Instructor> instructors = [Instructor()];

  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          floatingActionButton: BlocConsumer<AdminDataBloc, AdminDataStates>(
              buildWhen: (_, state) => state is CreateGroupState,
              listenWhen: (_, state) => state is CreateGroupState,
              listener: (context, state) {
                if (state.status == AdminDataStatus.loaded) {
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) =>
                  state.status == AdminDataStatus.loading
                      ? const CircularProgressIndicator()
                      : FloatingActionButton(
                          backgroundColor: ColorManager.darkGrey,
                          child: const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Map<String, dynamic> data = createMap();
                              //   final Course groupData;
                              //   final List<String> instructorsMails;
                              //   final List<String> titles;
                              context.read<AdminDataBloc>().add(
                                  CreateGroupEvent(
                                      Course.fromJson(data, ""),
                                      data['instructorsEmails'],
                                      data['titles']));
                            }
                          },
                        )),
          appBar: AppBar(
            shape: StyLeManager.appBarShape,
            foregroundColor: Colors.white,
            title: const Text('Add Group'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Form(
                    key: formKey,
                    child: DefaultFormField(
                      border: true,
                      controller: sheetName,
                      title: "Group name",
                      prefix: Icons.drive_file_rename_outline,
                      validator: (val) =>
                          val!.isEmpty ? "Name cannot be empty" : null,
                    )),
                IconStepper(
                  lineDotRadius: 1,
                  stepRadius: 20,
                  enableNextPreviousButtons: false,
                  activeStepColor: ColorManager.mainBlue,
                  icons: const [
                    Icon(Icons.table_rows_outlined),
                    Icon(Icons.info_outline),
                    Icon(Icons.add_box_outlined),
                    Icon(Icons.person_add_alt),
                  ],
                  activeStep: activeStep,
                  onStepReached: (index) {
                    setState(() {
                      activeStep = index;
                    });
                  },
                ),
                [
                  firstStep(),
                  secondStep(),
                  thirdStep(),
                  forthStep()
                ][activeStep],
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      previousButton(),
                      nextButton(),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget firstStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'choose student information',
              style: TextStyle(
                  fontSize: 20,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          chooseColumnName(),
        ],
      );

  Widget secondStep() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: descriptionController(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Price",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 200, child: NumericField(priceController)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Number of sessions",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 150, child: NumericField(numberOfSessions)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          startDateButton(),
          const SizedBox(
            height: 10,
          ),
          photoButton()
        ],
      );

  Widget thirdStep() => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          DefaultFormField(
              border: true,
              controller: offer,
              title: "Offers",
              prefix: FontAwesomeIcons.moneyBill),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Max Student",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.bold)),
              const Text("Keep empty if not",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.w400)),
              SizedBox(width: 120, child: NumericField(maxStudents)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Group category",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.bold)),
              categoryMenu(true),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Attendance type",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.bold)),
              categoryMenu(false),
            ],
          ),
        ],
      );

  Widget forthStep() => Column(
        children: [
          const Text("Instructors",
              style: TextStyle(
                  fontSize: 20,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.bold)),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: ColorManager.darkGrey.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            DefaultFormField(
                                controller: instructors[index].nameController,
                                title: "Instructor ${index + 1} name",
                                prefix: Icons.person),
                            const SizedBox(height: 10),
                            DefaultFormField(
                                controller: instructors[index].emailController,
                                keyboardType: TextInputType.emailAddress,
                                title: "Instructor ${index + 1} email",
                                prefix: Icons.email_outlined)
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              instructors.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ))
                    ],
                  ),
              itemCount: instructors.length),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              instructors.add(Instructor());
            }),
            label: const Text("Add instructor"),
            icon: const Icon(Icons.person_add_alt),
          )
        ],
      );

  //********************************************************************************//
  Widget chooseColumnName() => Wrap(
      children: List.generate(
          _columnsNames.length,
          (index) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: FilterChip(
                  selected: neededColumns[index],
                  label: Text(
                    _columnsNames[index],
                  ),
                  backgroundColor: Colors.transparent,
                  shape: const StadiumBorder(side: BorderSide()),
                  onSelected: (bool value) {
                    if (index < 2) return;
                    setState(() {
                      neededColumns[index] = value;
                    });
                  },
                ),
              )));

  Widget categoryMenu(bool which) => Container(
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                color: ColorManager.darkGrey.withOpacity(0.4), width: 2.0)),
        child: DropdownButton<String>(
          value: which ? category : inPlace,
          elevation: 0,
          items: (which
                  ? ['Course', 'Event', 'Workshop', 'Competition', 'internship']
                  : ["in place", "online", "hybrid"])
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              if (which) {
                category = val!;
              } else {
                inPlace = val!;
              }
            });
          },
        ),
      );

  Widget descriptionController() => TextFormField(
        controller: description,
        minLines: 5,
        maxLines: 7,
        validator: (value) =>
            value!.isEmpty ? "Description cannot be empty" : null,
        decoration: InputDecoration(
          labelText: "Description",
          prefixIcon: const Icon(Icons.message_outlined),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorManager.darkGrey.withOpacity(0.4), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  bool photoLoading = false;
  Widget photoButton() => SizedBox(
        width: double.infinity,
        child: Row(
          // mainAxisAlignment: M,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  XFile? photo = await takePhoto(context);
                  if (photo != null) {
                    setState(() {
                      photoLoading = true;
                    });
                    link = await uploadFile(File(photo.path));
                    setState(() {
                      photoLoading = false;
                    });
                  }
                },
                icon: photoLoading
                    ? const CircularProgressIndicator()
                    : Icon(link == null ? Icons.screenshot : Icons.check),
                label: const Text("upload Poster"),
              ),
            ),
            Visibility(
                visible: link != null,
                child: Hero(
                  tag: 'image',
                  child: IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: () {
                      navigateAndPush(context, ViewPhoto(link!));
                    },
                  ),
                ))
          ],
        ),
      );

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        if (activeStep < 3) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: const Text('Next'),
    );
  }

  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: const Text('Previous'),
    );
  }

  Widget startDateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Start date',
          style: TextStyle(
              fontSize: 18,
              color: ColorManager.darkGrey,
              fontWeight: FontWeight.bold),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: InkWell(
            key: Key(startDate.toString()),
            onTap: () async {
              startDate = await _selectDate(context: context);
              setState(() {});
            },
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: ColorManager.darkGrey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  DateFormat('dd-MM-yyyy').format(startDate),
                  style: const TextStyle(
                      color: ColorManager.mainBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<XFile?> takePhoto(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      return pickedFile;
    } else {
      showToast("cannot open gallery");
    }
    return null;
  }

  Future<String> uploadFile(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("Logos").child("file" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot task = await uploadTask.catchError((err) {
      showToast("Error while uploading the photo..");
    });
    String link = await task.ref.getDownloadURL();
    return link;
  }

  Future<DateTime> _selectDate({required BuildContext context}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(DateTime.now().year, 1),
        lastDate: DateTime(DateTime.now().year + 2, 12));
    return picked ?? DateTime.now();
  }

  Map<String, dynamic> createMap() {
    List<String> renameRowsName = [];
    for (int i = 0; i < neededColumns.length; i++) {
      if (neededColumns[i]) {
        renameRowsName.add(_columnsNames[i]);
      }
    }

    return {
      'columnNames': neededColumns,
      'titles': renameRowsName,
      "name": sheetName.text,
      "maxStudents": int.parse(maxStudents.text),
      "numberOfSessions": int.parse(numberOfSessions.text),
      "priceController": int.parse(priceController.text),
      "description": description.text,
      "offer": offer.text,
      "category": category,
      "inPlace": inPlace,
      "logo": link,
      "startDate": DateFormat('dd-MM-yyyy').format(startDate),
      "instructorsNames": instructors.map((e) => e.name).toList(),
      "instructorsEmails": instructors.map((e) => e.email).toList(),
    };
  }
}
