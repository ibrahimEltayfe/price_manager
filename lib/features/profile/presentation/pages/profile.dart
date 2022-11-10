import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_manager/core/constants/app_icons.dart';
import 'package:price_manager/core/constants/app_routes.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/reusable_components/responsive/fitted_icon.dart';
import 'package:price_manager/reusable_components/responsive/fittted_text.dart';
import 'package:price_manager/reusable_components/responsive/fractionally_icon.dart';
import 'package:price_manager/reusable_components/responsive/fractionally_text.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.height*0.03,),
            Padding(
              padding: EdgeInsets.only(left: context.width*0.03),
              child: Align(
                alignment: Alignment.topLeft,
                child: FittedIcon(
                  width: context.width*0.08,
                  height: context.height*0.035,
                  icon: AppIcons.arrowLeft,
                  color: AppColors.black,
                ),
              ),
            ),

            SizedBox(height: context.height*0.03,),
            Padding(
              padding: EdgeInsets.only(right: context.width*0.03),

              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(
                  "ابراهيم عز الدين الطايفى",
                  maxFontSize: 22,
                  minFontSize: 22,
                  style: getBoldTextStyle(),
                  maxLines: 1,
                ),
              ),
            ),

            SizedBox(height: context.height*0.01,),
            Padding(
              padding: EdgeInsets.only(right: context.width*0.03),
              child: Align(
                alignment: Alignment.centerRight,

                child: AutoSizeText(
                  "ibrahimeltayfe@gmail.com",
                  maxFontSize: 18,
                  minFontSize: 18,
                  style: getBoldTextStyle(color: AppColors.darkGrey,fontFamily: 'sen'),
                  maxLines: 1,
                ),
              ),
            ),

            SizedBox(height: context.height*0.05,),
            _BuildButtonWithShadow(
              icon:AppIcons.lock,
              text:AppStrings.changePassword,
              iconColor: AppColors.black,
              onTap:(){
                Navigator.pushNamed(context, AppRoutes.changePasswordPage);
              }
            ),

            SizedBox(height: context.height*0.03,),
            _BuildButtonWithShadow(
                icon:AppIcons.logOut,
                text:AppStrings.logout,
                iconColor:AppColors.darkRed,
                onTap:() async{
                  await FirebaseAuth.instance.signOut().whenComplete((){
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginPageRoute, (route) => false);
                  });
                }
            ),

          ],
        ),
      );
  }
}

class _BuildButtonWithShadow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color iconColor;
  const _BuildButtonWithShadow({Key? key, required this.icon, required this.text, required this.onTap, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width*0.03),
        child: Container(
          width: context.width,
          height: context.height*0.09,
          decoration: getContainerDecoration(
            offset: Offset(0,context.height*0.005),
            blurRadius: 6
          ),

          child: Row(
            children: [
              SizedBox(width: context.width*0.04,),
              if(text==AppStrings.changePassword)
                FittedIcon(
                  height: double.infinity,
                  width: context.width*0.038,
                  icon: AppIcons.roundedArrowLeft,
                  color: AppColors.black,
                ),

              Spacer(),

              FittedText(
                height: double.infinity,
                width: context.width*0.3,
                text: text,
                textStyle: getBoldTextStyle(),
              ),

              SizedBox(width: context.width*0.04,),

              FittedIcon(
                height: double.infinity,
                width: context.width*0.055,
                icon: icon,
                color: iconColor,
              ),

              SizedBox(width: context.width*0.04,),

            ],
          ),
        ),
      ),
    );
  }
}
