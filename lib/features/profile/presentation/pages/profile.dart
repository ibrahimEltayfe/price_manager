import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:price_manager/core/constants/app_routes.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: context.height*0.05,),

          ElevatedButton(
           onPressed: () async{
            await FirebaseAuth.instance.signOut().whenComplete((){
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginPageRoute, (route) => false);
            });
          },
           child: Text("Logout")
          )
        ],
      ),
    );
  }
}
