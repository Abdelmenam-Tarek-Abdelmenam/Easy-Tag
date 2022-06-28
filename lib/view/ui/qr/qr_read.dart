import 'dart:convert';
import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:r_scan/r_scan.dart';
import '../../resources/color_manager.dart';
import '../../shared/widgets/app_bar.dart';
import '../../shared/widgets/toast_helper.dart';

class QrReadScreen extends StatefulWidget {
  const QrReadScreen({Key? key}) : super(key: key);

  @override
  _QrReadScreenState createState() => _QrReadScreenState();
}

class _QrReadScreenState extends State<QrReadScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          "Scan The QR",
          actions: [
            TextButton(
                onPressed: () async {
                  if (await Permission.camera.request().isGranted) {
                    XFile? xFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (xFile != null) {
                      // File file = File(xFile.path);
                      final result = await RScan.scanImagePath(xFile.path);
                      String data = result.message ?? "";
                      if (data.isEmpty) {
                        showToast("No Data Detected");
                      } else {
                        _encodedData(data);
                      }
                    } else {
                      showToast("cannot open gallery");
                    }
                  }
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
                child: Row(
                  children: const [
                    Text('From Files'),
                    Icon(Icons.upload_file),
                  ],
                ))
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              heroTag: 'tag1',
              child: const Icon(Icons.highlight_rounded),
              backgroundColor: Colors.white,
              foregroundColor: ColorManager.mainBlue,
              onPressed: () {
                controller.toggleFlash();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              heroTag: 'tag2',
              child: const Icon(Icons.camera_alt_outlined),
              backgroundColor: Colors.white,
              foregroundColor: ColorManager.mainBlue,
              onPressed: () {
                controller.flipCamera();
              },
            ),
          ],
        ),
        body: BlocListener<StudentDataBloc, StudentDataStates>(
          listenWhen: (_, state) => state is QrReadState,
          listener: (context, state) {
            if (state.status == StudentDataStatus.loaded) {
              Navigator.of(context).pop();
            }
            if (state.status == StudentDataStatus.error) {
              controller.resumeCamera();
            }
          },
          child: _createScanUi(),
        ));
  }

  Widget _createScanUi() {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blueAccent,
        borderRadius: 10,
        borderLength: 130,
        borderWidth: 5,
      ),
    );
  }

  void _encodedData(String roomsString) async {
    controller.pauseCamera();

    try {
      final decodeBase64Json = base64.decode(roomsString);
      String originalJson = utf8.decode(decodeBase64Json);
      Map<String, dynamic> qrData = json.decode(originalJson);

      StudentDataBloc bloc = context.read<StudentDataBloc>();
      if (bloc.state.registeredId.contains(qrData['id'])) {
        int qrTimeDifference = DateTime.now()
            .difference(DateTime.parse(qrData['date']))
            .inMinutes
            .abs();
        if (qrTimeDifference < qrData['expire']) {
          showToast("Register you in server please wait", type: ToastType.info);
          bloc.add(QrReadEvent(qrData['id']));
        } else {
          showToast("QR expired");
          controller.resumeCamera();
        }
      } else {
        controller.resumeCamera();
        showToast("You are not registered in this course");
      }
    } catch (err) {
      showToast("invalid Data read,Try again");
      controller.resumeCamera();
      return;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        showToast("QR Detected", type: ToastType.info);
        String? readData = scanData.code;
        if (readData != null) {
          _encodedData(readData);
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
