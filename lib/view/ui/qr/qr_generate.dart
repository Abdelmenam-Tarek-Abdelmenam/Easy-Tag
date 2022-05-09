import 'dart:convert';
import 'dart:io';

import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../resources/color_manager.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen(this.id, {Key? key}) : super(key: key);
  final String id;

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  bool qrReady = false;
  int expireMinutes = 5;

  String? qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Generate QR Code'),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: createQrUi()),
            sliderWidget(),
          ],
        ),
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
            : InkWell(
                onTap: () {
                  _roomsDecodedData();
                  setState(() {
                    qrReady = true;
                  });
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: ColorManager.mainBlue,
                    borderRadius: BorderRadius.circular(10),
                    //border: Border.all(width: 2,color: ColorManager.mainBlue)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.qrcode,
                        size: 60,
                        color: ColorManager.whiteColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Generate",
                        style: TextStyle(
                            color: ColorManager.whiteColor, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget sliderWidget() {
    return Visibility(
      visible: !qrReady || qrData == null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Expire time : ",
                style: TextStyle(
                    color: ColorManager.mainBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          SfSlider(
            activeColor: ColorManager.mainBlue,
            min: 0.0,
            max: 5.0,
            value: expireMinutes,
            interval: 1,
            stepSize: 1,
            tooltipTextFormatterCallback: (_, integer) => labelText(integer),
            labelFormatterCallback: (_, integer) => labelText(integer),
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            minorTicksPerInterval: 1,
            onChanged: (value) {
              setState(() {
                expireMinutes = value.round();
              });
            },
          ),
        ],
      ),
    );
  }

  String labelText(String integer) => [
        "5m",
        "15m",
        "30m",
        "1h",
        "12h",
        "1d",
      ][int.parse(integer).round()];

  void _roomsDecodedData() {
    Map<String, dynamic> registerData = {
      "id": widget.id,
      "date": DateTime.now().toString(),
      "expire": [5, 15, 30, 60, 720, 1440][expireMinutes],
    };

    String realData = json.encode(registerData);
    final enCodedJson = utf8.encode(realData);
    final gZipJson = gzip.encode(enCodedJson);
    qrData = base64.encode(gZipJson);
  }
}
