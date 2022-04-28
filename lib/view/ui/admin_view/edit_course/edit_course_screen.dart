import 'dart:io';
import 'package:auto_id/model/module/course.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../resources/color_manager.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/form_field.dart';
import '../../../shared/widgets/toast_helper.dart';
import '../add_group/widgets/numeric_field.dart';
import '../add_group/widgets/view_photo.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;
  const EditCourseScreen(this.course, {Key? key}) : super(key: key);

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  var formKey = GlobalKey<FormState>();

  late TextEditingController sheetName =
      TextEditingController(text: widget.course.name);

  late TextEditingController numberOfSessions =
      TextEditingController(text: widget.course.numberOfSessions.toString());

  late TextEditingController priceController =
      TextEditingController(text: widget.course.price.toString());

  late TextEditingController description =
      TextEditingController(text: widget.course.description);

  late TextEditingController offer =
      TextEditingController(text: widget.course.offer);

  late String category = widget.course.category;

  late String inPlace = widget.course.inPlace;

  late String? link = widget.course.logo;

  late DateTime startDate = DateFormat('dd-MM-yyyy').parse(widget.course.date);

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
          appBar: appBar('Edit'),
          floatingActionButton: BlocConsumer<AdminDataBloc, AdminDataStates>(
              buildWhen: (_, state) => state is CreateGroupState,
              listenWhen: (_, state) => state is CreateGroupState,
              listener: (context, state) {
                if (state.status == AdminDataStatus.loaded) {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
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
                              context
                                  .read<AdminDataBloc>()
                                  .add(EditGroupEvent(data, widget.course.id));
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
                      prefix: Icons.drive_file_rename_outline,
                      validator: (val) =>
                          val!.isEmpty ? "Name cannot be empty" : null,
                    )),
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
                    const Text("Number of sessions",
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
                photoButton(),
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
            ),
          )),
    );
  }

  //********************************************************************************//
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
                child: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    navigateAndPush(context, ViewPhoto(link!));
                  },
                ))
          ],
        ),
      );

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
    return {
      "name": sheetName.text,
      "numberOfSessions": int.parse(numberOfSessions.text),
      "priceController": int.parse(priceController.text),
      "description": description.text,
      "offer": offer.text,
      "category": category,
      "inPlace": inPlace,
      "logo": link,
      "startDate": DateFormat('dd-MM-yyyy').format(startDate),
    };
  }
}
