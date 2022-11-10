import 'package:flutter/material.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../reusable_components/responsive/fittted_text.dart';
import '../../../../reusable_components/responsive/fractionally_text.dart';

class ShowProductsButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const ShowProductsButton({Key? key, required this.onTap, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedText(
                height: context.height*0.06,
                width: context.width*0.58 ,
                alignment: Alignment.center,
                text:title,
                textStyle: getBoldTextStyle(),
              ),

              Container(
                height: context.height*0.056,
                width: context.width*0.35,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.darkBlue,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: FractionallyText(
                  text: "إظهار",
                  textStyle: getBoldTextStyle(color: AppColors.darkBlue),
                  heightFactor: 0.7,
                  widthFactor: 0.7,
                  alignment: Alignment.center,
                ),
              )
            ],
          )
      ),
    );
  }
}
