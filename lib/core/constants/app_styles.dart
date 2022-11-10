import 'package:flutter/material.dart';

import 'app_colors.dart';

TextStyle _getTextStyle(double fontSize, Color color,String fontFamily,TextDecoration? textDecoration,FontWeight? fontWeight){
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
    decoration: textDecoration,
    fontWeight: fontWeight,
  );
}

TextStyle getRegularTextStyle({
         double fontSize = 20,
         Color color = Colors.black,
         String fontFamily = 'dubai',
         TextDecoration? textDecoration,
         FontWeight? fontWeight,

}) {
  return _getTextStyle(fontSize,color,fontFamily,textDecoration,fontWeight);
}

TextStyle getBoldTextStyle({
  double fontSize = 18,
  Color color = Colors.black,
  String fontFamily = 'dubai',
  FontWeight fontWeight = FontWeight.bold,
  TextDecoration? textDecoration
}) {
  return _getTextStyle(fontSize,color,fontFamily,textDecoration,fontWeight);
}

//button styles
ButtonStyle getRegularButtonStyle({required Color bgColor,required double radius}){
  return ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    backgroundColor: MaterialStateProperty.all<Color>(bgColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide.none
        )
    ),
    overlayColor:MaterialStateProperty.all<Color>(AppColors.white.withOpacity(0.05)),
  );
}

ButtonStyle getBorderedButtonStyle({required Color bgColor,required double radius}){
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(bgColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: AppColors.mediumGrey)
          )
      ),
      elevation: MaterialStateProperty.all(0)
  );
}

ButtonStyle getDialogButtonStyle(bool isAllow){
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(isAllow?AppColors.primaryColor:AppColors.lightGrey),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none
          )
      ),
      elevation: MaterialStateProperty.all(0)
  );
}

BoxDecoration getContainerDecoration(
{
  double borderRadius = 20,
  double blurRadius = 8,
  required Offset offset,
  Color bgColor = Colors.white
}
){
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: blurRadius,
        offset: offset,
      ),
    ],
    color: bgColor,
  );
}

BoxDecoration getOutlineBorderedDecoration(
    {
      double borderRadius = 20,
      Color borderColor = AppColors.black
    }
  ){
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: borderColor
    )
  );
}

OutlineInputBorder getTextFieldRadiusBorder({double radius = 15}){
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none
  );
}
