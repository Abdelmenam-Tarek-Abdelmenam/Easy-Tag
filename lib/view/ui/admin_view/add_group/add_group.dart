import 'dart:io';
import 'package:auto_id/view/shared/functions/image_functions.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/shared/widgets/form_field.dart';
import 'package:auto_id/view/ui/admin_view/add_group/models.dart';
import 'package:auto_id/view/ui/admin_view/add_group/widgets/numeric_field.dart';
import 'package:auto_id/view/ui/admin_view/add_group/widgets/view_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/functions/navigation_functions.dart';

List<String> columnsNames = const [
  "UID",
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
  ImageHelper imageHelper = ImageHelper();

  List<bool> neededColumns =
      List.generate(columnsNames.length, (index) => index < 2);

  var formKey = GlobalKey<FormState>();
  var sheetName = TextEditingController();
  var formLink = TextEditingController();
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
          appBar: appBar('add Group'),
          floatingActionButton: BlocConsumer<AdminDataBloc, AdminDataStates>(
              buildWhen: (_, state) => state is CreateGroupState,
              listenWhen: (_, state) => state is CreateGroupState,
              listener: (context, state) {
                if (state.status == AdminDataStatus.loaded) {
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) => state is CreateGroupState &&
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

                          context
                              .read<AdminDataBloc>()
                              .add(CreateGroupEvent(data));
                        }
                      },
                    )),
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
                      prefix: Icons.group_add,
                      validator: (val) =>
                          val!.isEmpty ? "Name cannot be empty" : null,
                    )),
                IconStepper(
                  lineDotRadius: 1,
                  stepRadius: 18,
                  enableNextPreviousButtons: false,
                  activeStepColor: ColorManager.mainBlue,
                  icons: const [
                    Icon(
                      Icons.table_rows_outlined,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.add_box_outlined,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.person_add_alt,
                      color: Colors.white,
                    ),
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
                      Visibility(
                          child: previousButton(), visible: activeStep != 0),
                      Visibility(child: nextButton(), visible: activeStep != 3),
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
              'Select Students Data',
              style: TextStyle(
                  fontSize: 20,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DefaultFormField(
                controller: formLink,
                title: "registration Form if exist",
                prefix: Icons.link),
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
              const Text(" Price",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorManager.darkGrey,
                  )),
              SizedBox(width: 200, child: NumericField(priceController)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Course Duration",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorManager.darkGrey,
                  )),
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
              const Text("Group Category",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorManager.darkGrey,
                  )),
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
                  )),
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
                                title: "Instructor ${index + 1} Name",
                                prefix: Icons.person),
                            const SizedBox(height: 10),
                            DefaultFormField(
                                controller: instructors[index].emailController,
                                keyboardType: TextInputType.emailAddress,
                                title: "Instructor ${index + 1} Email",
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
          columnsNames.length,
          (index) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: FilterChip(
                  selected: neededColumns[index],
                  label: Text(
                    columnsNames[index],
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
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: ColorManager.mainBlue)),
        width: 120,
        height: 40,
        child: DropdownButton<String>(
          underline: Container(),
          //alignment: Alignment.center,
          isExpanded: true,
          dropdownColor: Colors.blue[100],
          value: which ? category : inPlace,
          elevation: 0,
          items: (which
                  ? ['Course', 'Event', 'Workshop', 'Competition', 'Internship']
                  : ['in place', 'online', 'hybrid'])
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
                  XFile? photo = await imageHelper.takePhoto(context);
                  if (photo != null) {
                    setState(() {
                      photoLoading = true;
                    });
                    link = await imageHelper.uploadFile(File(photo.path));
                    setState(() {
                      photoLoading = false;
                    });
                  }
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(ColorManager.mainBlue),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: ColorManager.mainBlue))),
                icon: photoLoading
                    ? const CircularProgressIndicator()
                    : Icon(link == null ? Icons.image : Icons.check),
                label: const Text("Upload Poster"),
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
    return TextButton(
      onPressed: () {
        if (activeStep < 3) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: Row(
        children: const [
          Text(
            'Next',
            style: TextStyle(fontSize: 18),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget previousButton() {
    return TextButton(
      onPressed: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Row(
        children: const [
          Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
          Text(
            'Back',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget startDateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          ' Start date',
          style: TextStyle(
            fontSize: 18,
            color: ColorManager.darkGrey,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all(ColorManager.mainBlue)),
            key: Key(startDate.toString()),
            onPressed: () async {
              startDate = await _selectDate(context: context);
              setState(() {});
            },
            child: Text(
              DateFormat('dd-MM-yyyy').format(startDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
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
    renameRowsName.add("RFID");
    for (int i = 0; i < neededColumns.length; i++) {
      if (neededColumns[i]) {
        renameRowsName.add(columnsNames[i]);
      }
    }

    return {
      'columnNames': neededColumns,
      'titles': renameRowsName,
      "name": sheetName.text,
      "numberOfSessions": int.parse(numberOfSessions.text),
      "priceController": int.parse(priceController.text),
      "description": description.text,
      "offer": offer.text,
      "category": category,
      "inPlace": inPlace,
      "logo": link,
      "registrationForm": formLink.text,
      "startDate": DateFormat('dd-MM-yyyy').format(startDate),
      "instructorsNames": instructors.map((e) => e.name).toList(),
      "instructorsEmails": instructors.map((e) => e.email).toList(),
    };
  }
}
