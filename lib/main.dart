import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/bloc/student_bloc/student_data_bloc.dart';
import 'package:auto_id/bloc/student_exam_bloc/student_exam_bloc.dart';
import 'package:auto_id/model/fcm/fire_message.dart';
import 'package:auto_id/view/ui/admin_view/main_screen/main_screen.dart';
import 'package:auto_id/view/ui/start_screen/signing/login_screen.dart';
import 'package:auto_id/view/ui/student_view/main_screen/main_screen.dart';

import 'model/local/pref_repository.dart';
import 'model/module/app_admin.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/string_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc/auth_status_bloc.dart';
import 'view/shared/platforms.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white.withOpacity(0),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));

  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Platform.execute(
        mobile: () async {
          await Firebase.initializeApp();
          FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
          FlutterError.onError =
              FirebaseCrashlytics.instance.recordFlutterError;
          FireNotificationHelper();
        },
        web: () async {
          try {
            WidgetsFlutterBinding.ensureInitialized();
            await Firebase.initializeApp(
                name: 'auto-id',
                options: const FirebaseOptions(
                    apiKey: "AIzaSyA8sWc0zInh0HX6NdZboODIV0QgqaBVmZ4",
                    authDomain: "id-presence.firebaseapp.com",
                    databaseURL:
                        "https://id-presence-default-rtdb.firebaseio.com",
                    projectId: "id-presence",
                    storageBucket: "id-presence.appspot.com",
                    messagingSenderId: "545450328331",
                    appId: "1:545450328331:web:88f680a8579dff26d8220e",
                    measurementId: "G-M3ETBGJ21H"));
          } catch (e) {
            print("already initialize");
          }
        },
      );
      await PreferenceRepository.initializePreference();
      User? user = FirebaseAuth.instance.currentUser;
      AppAdmin tempUser = AppAdmin.empty;
      bool isAdmin = false;
      if (user != null) {
        tempUser = AppAdmin.fromFirebaseUser(user);
        isAdmin = await tempUser.isAdmin;
      }
      runApp(MyApp(tempUser, isAdmin));
    },
    // blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final AppAdmin user;
  final bool isAdmin;
  const MyApp(this.user, this.isAdmin, {Key? key}) : super(key: key);
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
        BlocProvider(
          create: (_) => StudentExamBloc(),
        ),
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
            ? const LoginView()
            : isAdmin
                ? MainScreen()
                : StudentMainScreen(),
      ),
    );
  }
}
