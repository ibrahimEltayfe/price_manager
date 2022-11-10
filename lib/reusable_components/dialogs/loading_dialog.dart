import 'package:flutter/material.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import '../../../core/constants/app_colors.dart';

Future<bool?> showLoadingDialog(context, {GlobalKey? key}) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return _AlertDialog(key: key,);
      });
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 120, vertical: 270),
      content: Center(
        child: SizedBox(
            width: context.width*0.5,
            height: context.height*0.5,
            child: Center(child: CircularProgressIndicator(color: AppColors.secondaryColor))
        ),
      ),
    );
  }
}

