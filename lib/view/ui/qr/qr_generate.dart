import 'dart:convert';
import 'dart:io';

import 'package:auto_id/view/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/ui/qr/qr_read.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  bool qrReady = false;
  String? qrData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateAndPush(context, const QrReadScreen());
          },
          child: const Icon(Icons.qr_code_scanner),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back)),
                  ),
                  createQrUi(),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton.icon(
                      onPressed: () {
                        _roomsDecodedData();
                        setState(() {
                          qrReady = true;
                        });
                      },
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.blue))),
                      label: const Text(
                        "Generate",
                      ),
                      icon: const Icon(FontAwesomeIcons.qrcode)),
                ],
              ),
            )),
      ),
    );
  }

  Widget createQrUi() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(10),
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: qrReady && qrData != null
            ? QrImage(
                data: qrData!,
                semanticsLabel: 'Course registration',
                version: QrVersions.auto,
                size: 300,
                embeddedImage: const AssetImage('images/logo.png'),
                embeddedImageStyle:
                    QrEmbeddedImageStyle(size: const Size(50, 50)),
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text(
                      "SomeThing went wrong",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              )
            : const SizedBox(
                width: 300, height: 300, child: Icon(Icons.qr_code, size: 70)),
      ),
    );
  }

  void _roomsDecodedData() {
    Map<String, dynamic> registerData = {"Name": "menam"};

    String realData = json.encode(registerData);
    final enCodedJson = utf8.encode(realData);
    final gZipJson = gzip.encode(enCodedJson);
    qrData = base64.encode(gZipJson);
  }
}
