import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          elevation: 4,
          shadowColor: AppColors.shadowColor,
          iconTheme:const IconThemeData(color: AppColors.black) ,
          title: FittedBox(
            child: Text("تعديل كلمة السر",style: getBoldTextStyle(),),
          )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
