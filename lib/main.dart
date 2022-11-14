import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:price_manager/firebase_options.dart';
import 'package:price_manager/core/utils/bloc_observer.dart';
import 'package:price_manager/core/utils/injector.dart' as di;
import 'package:price_manager/core/utils/shared_pref.dart';
import 'app_routers.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //local firebase
  //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080,sslEnabled: false);
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  //GetIt injector
  di.init();

  //shared preference initialize
  await SharedPrefHelper.init();

  //bloc observer
  Bloc.observer = SimpleBlocObserver();

  runApp(
        DevicePreview(
           enabled: false,
           builder:(c)=> const MyApp(),
       )
  );

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DevicePreview.appBuilder(
      context, MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            theme: ThemeData(scaffoldBackgroundColor: AppColors.backgroundColor),
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.decidePageRoute,
            onGenerateRoute: RoutesManager.routes,
         ),
       
    );
  }
}


