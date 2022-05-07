import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/model/fcm/fire_message.dart';
import 'package:auto_id/view/ui/admin_view/main_screen/main_screen.dart';
import 'package:auto_id/view/ui/student_view/main_screen/main_screen.dart';

import 'bloc/my_bloc_observer.dart';
import 'model/module/app_admin.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/string_manager.dart';
import 'package:auto_id/view/ui/start_screen/onboarding/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc/auth_status_bloc.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white.withOpacity(0),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));

  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      // await PreferenceRepository.initializePreference();
      User? user = FirebaseAuth.instance.currentUser;
      FireNotificationHelper();
      AppAdmin tempUser = AppAdmin.empty;
      if (user != null) {
        tempUser = AppAdmin.fromFirebaseUser(user);
      }
      runApp(MyApp(tempUser));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final AppAdmin user;
  const MyApp(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthStatusBloc()),
        BlocProvider(
            create: (_) => AdminDataBloc()
              ..add(
                StartAdminOperations(user),
              )),
        BlocProvider(
            create: (_) => StudentDataBloc()
              ..add(
                StartStudentOperations(user),
              )),
      ],
      child: MaterialApp(
        title: StringManger.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          indicatorColor: ColorManager.whiteColor,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            circularTrackColor: ColorManager.whiteColor,
          ),
          primarySwatch: Colors.blue,
          primaryColor: ColorManager.mainBlue,
        ),
        home: user.isEmpty
            ? OnBoardingView()
            : user.isAdmin
                ? MainScreen()
                : StudentMainScreen(),
      ),
    );
  }
}
