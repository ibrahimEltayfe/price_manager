import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/profile/presentation/bloc/change_password_cubit/change_password_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../reusable_components/outline_border_text_field.dart';
import '../../../../reusable_components/responsive/fractionally_text.dart';
import '../../../../reusable_components/status_snackbar.dart';
import '../../../home/presentation/bloc/product_details/product_details_bloc.dart';
import '../bloc/profile_cubit/profile_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final TextEditingController oldPasswordController =
      TextEditingController();
  late final TextEditingController newPasswordController =
      TextEditingController();
  late final TextEditingController reEnterNewPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    reEnterNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          elevation: 4,
          shadowColor: AppColors.shadowColor,
          iconTheme: const IconThemeData(color: AppColors.black),
          title: FittedBox(
            child: Text(
              "تعديل كلمة السر",
              style: getBoldTextStyle(),
            ),
          )),
        body: SafeArea(
         child: Form(
           key: _formKey,
          onChanged: (){
             if(_formKey.currentState!.validate()){
               context.read<ChangePasswordCubit>().buttonStateChanger.changeState(true);
             }else{
               context.read<ChangePasswordCubit>().buttonStateChanger.changeState(false);
             }
          },
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.03,
                vertical: context.height * 0.05
            ),
            children: [
              OutlineBorderTextField(
                controller: oldPasswordController,
                hint: AppStrings.oldPassword,
                isNormalHint: true,
                isObscure: true,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }else if(value.length < 6){
                    return 'يجب ان يكون طول كلمة السر ٦ على الاقل';
                  }

                  return null;
                },

              ),

              SizedBox(height: context.height * 0.03,),

              OutlineBorderTextField(
                controller: newPasswordController,
                hint: AppStrings.newPassword,
                isNormalHint: true,
                isObscure: true,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }else if(value.length < 6){
                    return 'يجب ان يكون طول كلمة السر ٦ على الاقل';
                  }else if(value == oldPasswordController.text){
                    return 'كلمة السر الجديدة مطابقة للقديمة';
                  }

                  return null;
                },

              ),

              SizedBox(height: context.height * 0.03,),

              OutlineBorderTextField(
                controller: reEnterNewPasswordController,
                hint: AppStrings.reEnterNewPassword,
                isNormalHint: true,
                isObscure: true,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }else if(value != newPasswordController.text){
                    return 'كلمة السر الجديدة غير متطابقة';
                  }

                  return null;
                },
              ),

              SizedBox(height: context.height * 0.03,),

              _ChangePasswordButton(
                onTap: () {
                  if(_formKey.currentState!.validate()){
                    context.read<ChangePasswordCubit>().changePassword(
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text
                    );
                  }
                },
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom,),
            ],
          ),
        )));
  }
}

class _ChangePasswordButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ChangePasswordButton({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<ChangePasswordCubit>().buttonStateChanger.output,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          final bool isActive = snapshot.data ?? false;

          return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) async {
              if (state is PasswordChanged) {
                statusSnackBar(
                  context: context,
                  text: "تم التعديل",
                );
              } else if (state is ChangePasswordError) {
                statusSnackBar(
                  context: context, text: state.message, isError: true);
              }
            },
            builder: (context, state) {
              return AbsorbPointer(
                absorbing: !isActive,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                      width: context.width * 0.6,
                      height: context.height * 0.09,
                      decoration: getContainerDecoration(
                          offset: Offset(0, context.height * 0.008),
                          borderRadius: 20,
                          bgColor: isActive
                              ? AppColors.darkBlue
                              : AppColors.darkGrey
                           ),
                           child: state is ChangePasswordLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : FractionallyText(
                              widthFactor: 0.7,
                              heightFactor: 0.7,
                              text: "تغيير",
                              textStyle: getBoldTextStyle(
                                  color: AppColors.backgroundColor),
                              alignment: Alignment.center)),
                ),
              );
            },
          );
        });
  }
}
