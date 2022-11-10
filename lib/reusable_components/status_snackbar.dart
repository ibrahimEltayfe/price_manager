import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> statusSnackBar({
  required BuildContext context,
  required String text,
  bool isError = false
}){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError?AppColors.darkRed:AppColors.green,
        content: SizedBox(
          child: AutoSizeText(
          text,
          style: getBoldTextStyle(color: AppColors.backgroundColor),
          textAlign: TextAlign.center,
         ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(
            bottom: context.height*0.05,
            right: isError?context.width*0.05:context.width*0.26,
            left: isError?context.width*0.05:context.width*0.26
        ),
      ));
}