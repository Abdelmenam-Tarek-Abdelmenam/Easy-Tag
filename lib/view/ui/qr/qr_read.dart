import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


import '../../resources/color_manager.dart';
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
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.black,
            // foregroundColor: Colors.white,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () async {
                    if (await Permission.camera.request().isGranted) {
                      XFile? xFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (xFile != null) {
                        // File file = File(xFile.path);
                        final String data =
                            await FlutterQrReader.imgScan(xFile.path);
                        print("here");
                        if (data.isEmpty) {
                          showToast("No Data Detected");
                        } else {
                          showToast(data, type: ToastType.success);
                        }
                      } else {
                        showToast("cannot open gallery");
                      }
                    }
                  },
                  icon: const Icon(Icons.upload_file))
            ],
            title: const Text("Scan The QR"),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  color: ColorManager.mainBlue,
                  iconSize: 30,
                  splashRadius: 30,
                  icon: const Icon(Icons.highlight_rounded),
                  onPressed: () {
                    controller.toggleFlash();
                  },
                ),
                IconButton(
                  color: ColorManager.mainBlue,
                  iconSize: 30,
                  splashRadius: 30,
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    controller.flipCamera();
                  },
                )
              ],
            ),
          ),
          body: _createScanUi()),
    );
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
    final decodeBase64Json = base64.decode(roomsString);
    final decodeZipJson = gzip.decode(decodeBase64Json);
    String originalJson = utf8.decode(decodeZipJson);

    try {
      Map<String, dynamic> qrData = json.decode(originalJson);
      print(qrData);
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
          controller.pauseCamera();
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
