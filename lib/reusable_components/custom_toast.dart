import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(FToast fToast,String message,{Color color = AppColors.darkRed}) {
  ///show toast
  WidgetsBinding.instance.addPostFrameCallback((_){
    fToast.showToast(
      child: _buildToast(color: color,message: message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  });

  // Custom Toast Position
  /* fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: 16.0,
          left: 16.0,
        );
      });*/
}

class _buildToast extends StatelessWidget {
  final Color color;
  final String message;
  const _buildToast({Key? key, required this.color, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,style: TextStyle(
              fontFamily: 'dubai',
              fontSize: 16,
              color: Colors.white,
              overflow: TextOverflow.ellipsis
          ),),

        ],
      ),
    );
  }
}
