import 'dart:ui';

import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/view/ui/student_view/main_screen/main_screen.dart';

import '../../../../../../model/module/app_admin.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../bloc/auth_bloc/auth_status_bloc.dart';
import '../../../../../model/module/course.dart';
import '../../../../shared/functions/navigation_functions.dart';
import '../../../admin_view/main_screen/main_screen.dart';
import '../../../student_view/details_screen/details_screen.dart';
import 'clip_pathes.dart';
import 'forget_pass_dialog.dart';
import '../../../../shared/widgets/form_field.dart';

// ignore: must_be_immutable
class MainLoginWidget extends StatefulWidget {
  final Course? course;

  const MainLoginWidget(this.course, {Key? key}) : super(key: key);

  @override
  State<MainLoginWidget> createState() => _MainLoginWidgetState();
}

class _MainLoginWidgetState extends State<MainLoginWidget> {
  bool isLogin = true;
  bool showPassText = true;
  var logInEmailController = TextEditingController();
  var signUpEmailController = TextEditingController();
  var logInPassController = TextEditingController();
  var signUpPassController = TextEditingController();
  var passCheckerController = TextEditingController();
  var loginGlobalKey = GlobalKey<FormState>();
  var signUpGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 10.0,
          left: 10.0,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: defaultMainWidget(context),
    );
  }


  Widget defaultMainWidget(BuildContext context) => BlocListener<AuthStatusBloc, AuthStates>(
    listener: (context, state) async {
      if (state.status == AuthStatus.successLogIn) {
        AppAdmin appAdmin = context.read<AuthStatusBloc>().user;
        if (await appAdmin.isAdmin) {
          context
              .read<AdminDataBloc>()
              .add(StartAdminOperations(appAdmin));
          navigateAndReplace(context, MainScreen());
        } else {
          context
              .read<StudentDataBloc>()
              .add(StartStudentOperations(appAdmin));
          if (widget.course == null) {
            navigateAndReplace(context, StudentMainScreen());
          } else {
            navigateAndReplace(context, DetailsScreen(widget.course!));
          }
        }
      } else if (state.status == AuthStatus.successSignUp) {
        setState(() {
          isLogin = true;
        });
      }
    },
    child: AnimatedSwitcher(
        duration: const Duration(seconds: 3),
        child: isLogin ? logInWidget() : signUpWidget()),
  );

  Widget logInWidget() => Container(
    height: 500,
    width: MediaQuery.of(context).size.width * 0.92,
    color: Colors.white,
    child: BlocBuilder<AuthStatusBloc, AuthStates>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Login",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  color: ColorManager.darkGrey),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(child: underLine(width: 200)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
                key: loginGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultFormField(
                      prefix: Icons.mail,
                      controller: logInEmailController,
                      fillHint: AutofillHints.email,
                      title: "Email Address",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultFormField(
                      prefix: Icons.lock,
                      controller: logInPassController,
                      fillHint: AutofillHints.password,
                      title: "Password",
                      isPass: !showPassText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'password cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      suffix: IconButton(
                        icon: Icon(showPassText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          showPassText = !showPassText;
                          context
                              .read<AuthStatusBloc>()
                              .add(ChangeSomeUiEvent());
                        },
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Dialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20))),
                              child: ForgetPassword(),
                              //  contentPadding: const EdgeInsets.all(0.0),
                            ),
                          );
                        });
                  },
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: ColorManager.mainBlue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          usedButton(
              state.status == AuthStatus.submittingEmail
                  ? const CircularProgressIndicator()
                  : const Text(
                      "LOGIN",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ), () {
            if (loginGlobalKey.currentState!.validate()) {
              context.read<AuthStatusBloc>().add(LoginInUsingEmailEvent(
                  logInEmailController.text, logInPassController.text));
            }
          }),
          const SizedBox(
            height: 15,
          ),
          usedButton(
              state.status == AuthStatus.submittingGoogle
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Login using Google account",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),

                      ],
                    ), () {
            context.read<AuthStatusBloc>().add(LoginInUsingGoogleEvent());
          }),
          Center(
              child: Column(
            children:  [
              const SizedBox(height: 20,),
              const Text("If you don't have account yet, please"),
              TextButton(
                  onPressed: (){changeScreenMode();},
                  style: ButtonStyle(foregroundColor:
                  MaterialStateProperty.all(ColorManager.mainBlue)),
                  child: const Text('Signup'))
            ],
          )),
        ],
      ),
    ),
  );

  Widget signUpWidget() => Container(
    height: 500,
    width: MediaQuery.of(context).size.width * 0.92,
    decoration: const BoxDecoration(color: Colors.white),
    child: BlocBuilder<AuthStatusBloc, AuthStates>(
      builder: (context, state) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 8,
                ),
                underLine(width: 200),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
                key: signUpGlobalKey,
                child: Column(
                  children: [
                    DefaultFormField(
                      prefix: Icons.mail,
                      controller: signUpEmailController,
                      fillHint: AutofillHints.email,
                      title: "Email Address",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultFormField(
                      prefix: Icons.lock,
                      controller: signUpPassController,
                      fillHint: AutofillHints.newPassword,
                      title: "Password",
                      isPass: !showPassText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'password cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      suffix: IconButton(
                        icon: Icon(showPassText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          showPassText = !showPassText;
                          context
                              .read<AuthStatusBloc>()
                              .add(ChangeSomeUiEvent());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultFormField(
                      prefix: Icons.lock,
                      controller: passCheckerController,
                      fillHint: AutofillHints.newPassword,
                      title: "Password",
                      isPass: !showPassText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'password cannot be empty';
                        } else if (value != signUpPassController.text) {
                          return 'Password must be the same';
                        } else {
                          return null;
                        }
                      },
                      suffix: IconButton(
                        icon: Icon(showPassText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          showPassText = !showPassText;
                          context
                              .read<AuthStatusBloc>()
                              .add(ChangeSomeUiEvent());
                        },
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          usedButton(
              state.status == AuthStatus.submittingEmail
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ), () {
            if (signUpGlobalKey.currentState!.validate()) {
              context.read<AuthStatusBloc>().add(SignUpInUsingEmailEvent(
                  signUpEmailController.text, signUpPassController.text));
            }
          }),
          Center(
              child: Column(
                children:  [
                  const SizedBox(height: 20,),
                  const Text("already have account?"),
                  TextButton(
                      onPressed: (){changeScreenMode();},
                      style: ButtonStyle(foregroundColor:
                      MaterialStateProperty.all(ColorManager.mainBlue)),
                      child: const Text('Login'))
                ],
              )),
        ],
      ),
    ),
  );

  Widget underLine({double width = 75}) {
    return Container(
        width: width,
        margin: const EdgeInsets.only(
          left: 30,
        ),
        height: 12,
        child: const Card(elevation: 2, color: ColorManager.mainBlue));
  }

  Widget orLineWidget() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            const Text(
              '  OR  ',
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  Widget usedButton(Widget child, Function() onPressed) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        height: 50,
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

  void changeScreenMode() {
    showPassText = false;
    isLogin = !isLogin;
    setState(() {});
  }
}
