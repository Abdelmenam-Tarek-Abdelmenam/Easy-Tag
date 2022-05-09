// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/admin_bloc/admin_data_bloc.dart';
import '../../../../resources/color_manager.dart';
import '../../../../shared/widgets/form_field.dart';
import '../../../start_screen/signing/widgtes/clip_pathes.dart';

// ignore: must_be_immutable
class MainConfigWidget extends StatelessWidget {
  MainConfigWidget({Key? key}) : super(key: key);

  final TextEditingController wifiNameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
        left: 20.0,
      ),
      child: SizedBox(
        height: 400,
        child: defaultMainWidget(context),
      ),
    );
  }

  Widget defaultMainWidget(BuildContext context) => CustomPaint(
      painter: LoginShadowPaint(),
      child: Stack(
        children: [
          ClipPath(
            clipper: SignUpClipper(),
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.92,
              color: ColorManager.lightBlue.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          mainWidget(context)
        ],
      ));

  Widget mainWidget(BuildContext context) => ClipPath(
        clipper: LoginClipper(),
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.92,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 50, bottom: 5),
                child: const Text(
                  "Credentials",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: ColorManager.darkGrey),
                ),
              ),
              underLine(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultFormField(
                        controller: wifiNameController,
                        title: "WIFI name",
                        prefix: Icons.wifi,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Wifi NAME cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StatefulBuilder(
                          builder: (_, setState) => DefaultFormField(
                                controller: passController,
                                isPass: hidePassword,
                                suffix: IconButton(
                                  icon: Icon(hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                ),
                                title: "Password name",
                                prefix: Icons.lock,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'password NAME cannot be empty';
                                  } else {
                                    return null;
                                  }
                                },
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<AdminDataBloc, AdminDataStates>(
                            buildWhen: (perv, next) => next is SendEspDataState,
                            listenWhen: (perv, next) =>
                                next is SendEspDataState,
                            listener: (context, state) {
                              if ((state is SendEspDataState) &&
                                  (state.status == AdminDataStatus.loaded)) {
                                Navigator.of(context).pop();
                              }
                            },
                            builder: (context, state) => usedButton(
                                    (state is SendEspDataState) &&
                                            (state.status ==
                                                AdminDataStatus.loading)
                                        ? const CircularProgressIndicator()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "Send",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ), () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AdminDataBloc>().add(
                                        SendConfigurationEvent(
                                            wifiNameController.text,
                                            passController.text));
                                  }
                                })),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget underLine({double width = 120}) {
    return Container(
        width: width,
        margin: const EdgeInsets.only(
          left: 20,
        ),
        height: 12,
        child: const Card(elevation: 2, color: ColorManager.mainBlue));
  }

  Widget usedButton(Widget child, Function() onPressed) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ColorManager.mainBlue,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: MaterialButton(
          onPressed: onPressed,
          elevation: 2,
          child: child,
        ),
      );
}
