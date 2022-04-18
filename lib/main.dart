import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';

import 'bloc/my_bloc_observer.dart';
import 'model/module/app_admin.dart';
import 'view/ui/main_view/main_screen.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/string_manager.dart';
import 'package:auto_id/view/ui/start_screen/onboarding/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc/auth_status_bloc.dart';

import 'bloc/deprecated_cubit/admin_cubit.dart';
import 'model/local/pref_repository.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorManager.mainOrange,
  ));

  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await PreferenceRepository.initializePreference();
      User? user = FirebaseAuth.instance.currentUser;
      AppAdmin tempUser = AppAdmin.empty;
      if (user != null) {
        tempUser = AppAdmin.fromFirebaseUser(user);
      }

      runApp(MyApp(tempUser));
    },
    blocObserver: MyBlocObserver(),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final AppAdmin user;
  const MyApp(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthStatusBloc()),
        BlocProvider(create: (_) => AdminCubit()),
        BlocProvider(
            create: (_) => AdminDataBloc()..add(StartDataOperations(user))),
      ],
      child: MaterialApp(
        title: StringManger.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          indicatorColor: ColorManager.whiteColor,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            circularTrackColor: ColorManager.whiteColor,
          ),
          primarySwatch: Colors.orange,
          primaryColor: ColorManager.mainOrange,
        ),
        home: user.isEmpty ? OnBoardingView() : MainScreen(),
      ),
    );
  }
}
