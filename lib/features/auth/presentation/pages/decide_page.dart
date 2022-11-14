import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';

class DecidePage extends StatelessWidget {
  const DecidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo:account still have access after deletion from firebase
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_,AsyncSnapshot<User?> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.data?.uid != null){
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, AppRoutes.homePageRoute);
            });
          }else{
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, AppRoutes.loginPageRoute);
            });
          }
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.darkBlue,
            ),
          ),
        );
      }

    );
  }
}
