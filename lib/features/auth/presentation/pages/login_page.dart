import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:price_manager/core/constants/app_colors.dart';
import 'package:price_manager/core/constants/app_styles.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/auth/presentation/pages/widgets/auth_text_field.dart';
import 'package:price_manager/reusable_components/responsive/fractionally_text.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/validation.dart';
import '../../../../reusable_components/custom_toast.dart';
import '../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LogibPageState();
}

class _LogibPageState extends State<LoginPage>{
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final Validation _validation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FToast _ftoast = FToast();
  GlobalKey<State> key = GlobalKey();

  @override
  void initState() {
    _ftoast.init(context);
    _validation = Validation();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //image
                Padding(
                  padding: EdgeInsets.only(top: context.height*0.065),
                  child: SizedBox(
                      width: context.width*0.87,
                      height: context.width*0.34,
                      child: Image.asset(AppImages.authImage)
                  ),
                ),

                SizedBox(height: context.height*0.1,),

                //email
                AuthTextField(
                  hint: AppStrings.email,
                  controller: _emailController,
                  icon: Icons.email,
                  validator: (email){
                    String? message = _validation.emailValidator(email!.trim());
                    return message;
                  },
                ),

                SizedBox(height: context.height*0.04,),

                //password
                AuthTextField(
                  hint: AppStrings.password,
                  controller: _passwordController,
                  icon: Icons.lock,
                  isObscure: true,
                  validator: (password){
                      return _validation.loginPasswordValidator(password!);
                  },
                ),

                SizedBox(height: context.height*0.05,),

                //login button

                BlocConsumer<AuthBloc,AuthState>(
                    listener: (context,state){
                      /*if(state is AuthLoadingState){
                        //showLoadingDialog(context,key:key);
                      }else*/
                      if(state is AuthLoginSuccessState){
                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homePageRoute, (route) => false);
                      }else if(state is AuthErrorState){
                        // ** using global key - not working

                        /*if(key.currentContext!=null || key.currentWidget != null){
                          Navigator.of(context).pop();
                        }*/

                        showToast(_ftoast, state.message);
                      }
                    },
                    builder: (context,state) {
                      if(state is AuthLoadingState){
                        return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                      }
                      return Align(
                          alignment: Alignment.center,
                          child: _LoginButton(
                            label:AppStrings.login,
                            onTap: (){
                              if(_formKey.currentState!.validate()){
                                  context.read<AuthBloc>().add(
                                      LogInEvent(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim()
                                      )
                                  );
                              }
                            },
                          )
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _LoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LoginButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width*0.5,
        height: context.height*0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0x3fc9c9c9),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          color: Color(0xffe19c0e),
        ),
        child: FractionallyText(
          heightFactor: 0.61,
          widthFactor: 0.61,
          textStyle: getBoldTextStyle(color: AppColors.white) ,
          text: label,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

