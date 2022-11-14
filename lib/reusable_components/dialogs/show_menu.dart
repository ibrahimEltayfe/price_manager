import 'package:flutter/material.dart';
import 'package:price_manager/core/constants/app_strings.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/core/extensions/widget_offset.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

Future<void> showPopUpMenu(BuildContext context,GlobalKey key,void Function(int) onTap) async{

  final offset = key.currentContext?.globalPaintBounds;

  final left = offset?.left ?? 300;
  final top = offset?.top ?? 300;
  final right =offset?.right ?? 150;
  final bottom = offset?.bottom ?? 300;

  await showMenu(
    context: context,
    constraints: BoxConstraints(
        maxWidth: context.width*0.22,
        maxHeight: context.height*0.08,
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight:  Radius.circular(20)
        )
    ),
    position: RelativeRect.fromLTRB(left, top, right,bottom),
    items: List.generate(MenuItems.values.length, (i) {
      return PopupMenuItem<String>(
        textStyle: getBoldTextStyle(color:MenuItems.values[i]== MenuItems.delete?AppColors.darkRed:AppColors.black),
        onTap: (){
          onTap(i);
        },
        child: Center(
          child: FittedBox(
              child: Text(MenuItems.values[i].getText())
          ),
        ),
      );
    }),
    elevation: 8.0,
  );
}

enum MenuItems{
  delete,
}

extension MenuActions on MenuItems{
  String getText(){
    switch(this) {
      case MenuItems.delete: return AppStrings.delete;
    }
  }
}
