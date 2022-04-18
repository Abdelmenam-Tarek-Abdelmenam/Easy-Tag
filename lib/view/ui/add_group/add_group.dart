import 'dart:io';

import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/styles_manager.dart';
import 'package:auto_id/view/ui/add_group/widgets/numeric_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/widgets/form_field.dart';
import '../../shared/widgets/toast_helper.dart';

List<String> columnsNames = const [
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
class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  List<bool> neededColumns =
      List.generate(columnsNames.length, (index) => index < 2);

  var formKey = GlobalKey<FormState>();
  var sheetName = TextEditingController();
  var maxStudents = TextEditingController(text: "0");
  var priceController = TextEditingController(text: "1000");
  TextEditingController description = TextEditingController();
  TextEditingController offer = TextEditingController();
  String category = "Course";
  String? link;

  int activeIndex = 0;

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
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    List<String> renameRowsName = [];
                    for (int i = 0; i < neededColumns.length; i++) {
                      if (neededColumns[i]) {
                        renameRowsName.add(columnsNames[i]);
                      }
                    }
                    // context.read<AdminDataBloc>().add(AddGroupEvent());
                  }
                },
              ),
              appBar: AppBar(
                shape: StyLeManager.appBarShape,
                foregroundColor: Colors.white,
                title: const Text('Add Group'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconStepper(
                      lineDotRadius: 1,
                      stepRadius: 20,
                      enableNextPreviousButtons: false,
                      activeStepColor: ColorManager.mainOrange,
                      icons: const [
                        Icon(Icons.table_rows_outlined),
                        Icon(Icons.info_outline),
                        Icon(Icons.add_box_outlined),
                        Icon(Icons.person_add_alt),
                      ],
                      activeStep: activeIndex,
                      onStepReached: (index) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                    ),
                    [
                      firstStep(),
                      secondStep(),
                      thirdStep(),
                      forthStep()
                    ][activeIndex],
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
      },
    );
  }

  Widget firstStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              categoryMenu(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );

  Widget forthStep() => Column(
        children: const [],
      );

  Widget chooseColumnName() => Wrap(
      children: List.generate(
          columnsNames.length,
          (index) => StatefulBuilder(
                builder: (_, setState) {
                  return Padding(
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
                  );
                },
              )));

  Widget categoryMenu() => StatefulBuilder(
      builder: (_, setState) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: ColorManager.darkGrey.withOpacity(0.4), width: 2.0)),
            child: DropdownButton<String>(
              value: category,
              elevation: 0,
              items: <String>[
                'Course',
                'Event',
                'Workshop',
                'Competition',
                'internship'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  category = val!;
                });
              },
            ),
          ));

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
  Widget photoButton() => StatefulBuilder(
      builder: (_, setState) => SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                XFile? photo = await takePhoto(context);
                if (photo != null) {
                  setState(() {
                    photoLoading = true;
                  });
                  link = await uploadFile(File(photo.path), "logs");
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
          ));

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        if (activeIndex < 3) {
          setState(() {
            activeIndex++;
          });
        }
      },
      child: const Text('Next'),
    );
  }

  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        if (activeIndex > 0) {
          setState(() {
            activeIndex--;
          });
        }
      },
      child: const Text('Previous'),
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

  Future<String> uploadFile(File file, String place) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child(place).child("file" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot task = await uploadTask.catchError((err) {
      showToast("Error while uploading the photo..");
    });
    String link = await task.ref.getDownloadURL();
    return link;
  }
}
