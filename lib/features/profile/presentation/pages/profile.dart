import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_manager/core/constants/app_icons.dart';
import 'package:price_manager/core/constants/app_routes.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/profile/domain/entities/user_entity.dart';
import 'package:price_manager/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:price_manager/reusable_components/responsive/fitted_icon.dart';
import 'package:price_manager/reusable_components/responsive/fittted_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocListener<ProfileBloc,ProfileState>(
          listener: (context, state) {
           if(state is ProfileError){
              Fluttertoast.showToast(msg: state.message,backgroundColor: AppColors.darkRed,textColor: AppColors.backgroundColor);
            } else if(state is ProfileSignOut){
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginPageRoute, (route) => false);
            }
          },
          child: Stack(
            children: [

              Column(
                children: [
                  SizedBox(height: context.height*0.05,),
                  _BuildNameAndEmail(),

                  SizedBox(height: context.height*0.05,),
                  _BuildButtonWithShadow(
                      icon:AppIcons.lock,
                      text:AppStrings.changePassword,
                      iconColor: AppColors.black,
                      onTap:(){
                        Navigator.pushNamed(
                            context,
                            AppRoutes.changePasswordPage,
                            arguments: context.read<ProfileBloc>()
                        );
                      }
                  ),

                  SizedBox(height: context.height*0.03,),
                  _BuildButtonWithShadow(
                      icon:AppIcons.logOut,
                      text:AppStrings.logout,
                      iconColor:AppColors.darkRed,
                      onTap:(){
                        context.read<ProfileBloc>().add(ProfileSignOutEvent());
                      }
                  ),

                ],
              ),

              BlocSelector<ProfileBloc,ProfileState,bool>(
                selector: (state) {
                  return state is ProfileLoading;
                },
                builder: (context, loading) {
                  if(loading){
                    return AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                        width: context.width,
                        height: context.height,
                        child: Center(
                          child: Container(
                              width: context.width*0.4,
                              height: context.height*0.2,
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: AppColors.semiBlack.withOpacity(0.2)
                              ),
                              child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: CircularProgressIndicator(color: AppColors.primaryColor,)
                              )
                          ),
                        ),
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ],

          ),
        ),
      );
  }
}
class _BuildNameAndEmail extends StatelessWidget {
  const _BuildNameAndEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc,ProfileState>(
      builder: (context, state) {
        final UserEntity? user = context.read<ProfileBloc>().userEntity;

        return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: context.width*0.03),

                child: Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    user?.name??'...',
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
                    user?.email??'...',
                    maxFontSize: 18,
                    minFontSize: 18,
                    style: getBoldTextStyle(color: AppColors.darkGrey,fontFamily: 'sen'),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          );

      },
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
