
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_styles.dart';

showCustomDialog({
  required BuildContext context,
  required Widget icon,
  required Widget title,
  required VoidCallback allowTap,
  required VoidCallback notAllowTap,
}){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        icon: icon,
        title: title,
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide.none
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FractionallySizedBox(
            widthFactor: 0.36,
            child: ElevatedButton(
                onPressed: allowTap,
                style: getDialogButtonStyle(false),
                child: FittedBox(
                  child: Text(
                    'do not allow',
                    style: getBoldTextStyle(color: AppColors.semiBlack),
                  ),
                )
            ),
          ),

          FractionallySizedBox(
            widthFactor: 0.36,
            child: ElevatedButton(
                onPressed: notAllowTap,
                style: getDialogButtonStyle(true),
                child: FittedBox(
                  child: Text(
                    'allow',
                    style: getBoldTextStyle(color: AppColors.white),
                  ),
                )
            ),
          ),
        ],

      );
    },
  );
}