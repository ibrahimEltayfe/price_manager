import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_manager/core/constants/app_icons.dart';
import 'package:price_manager/core/constants/app_strings.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/core/utils/injector.dart' as di;
import 'package:price_manager/features/dashboard/presentation/pages/dashboard.dart';
import 'package:price_manager/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:price_manager/features/home/presentation/pages/home.dart';
import 'package:price_manager/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:price_manager/features/profile/presentation/pages/profile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  State<HomeBase> createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _BottomNavBar(
        activeColor: AppColors.primaryColor,
        currentIndex: currentIndex,
        disabledColor: AppColors.lightGrey ,
        icons: const [
          AppIcons.home,
          AppIcons.manage,
          AppIcons.profile
        ],
       // E4E4E4
        texts: const[
          AppStrings.home,
          AppStrings.manage,
          AppStrings.profile
        ],
        onTap: (i){
          setState(() {
            currentIndex = i;
          });
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            BlocProvider(
              create: (context)=> di.injector<HomeBloc>()..add(HomeLoadDataEvent()),
              child:Home()
            ),

            Dashboard(),

            BlocProvider(
                create: (context)=> di.injector<ProfileBloc>()..add(ProfileFetchDataEvent()),
                child: Profile()
            ),

          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final List<IconData> icons;
  final List<String> texts;
  final int currentIndex;
  final Color activeColor;
  final Color disabledColor;

  const _BottomNavBar({Key? key, required this.onTap, required this.icons, required this.texts, required this.currentIndex, required this.activeColor, required this.disabledColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = context.height*0.092;
    final width = context.width;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.width*0.06),
            topRight:  Radius.circular(context.width*0.06),
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.lightGrey,
                blurRadius: 6,
                offset: Offset(0,context.height*0.004)
            )
          ]
      ),

      child: Row(
          children:[
            ...List.generate(icons.length, (i){
              return _NavBarItem(
                index: i,
                textStyle: currentIndex==i
                    ? getBoldTextStyle(color: AppColors.black)
                    : getBoldTextStyle(color: AppColors.lightGrey),
                icon: icons[i],
                text: texts[i],
                iconColor:currentIndex==i? activeColor : disabledColor,
                onTap: onTap,
              );
            }).reversed,
          ]

      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final TextStyle textStyle;
  final int index;
  final Function(int) onTap;
  const _NavBarItem({Key? key, required this.icon, required this.iconColor, required this.text, required this.textStyle, required this.index, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: ()=> onTap(index),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width*0.007,vertical:context.height*0.017 ),
          child: Column(
            children: [

              Expanded(
                flex: 4,
                child: FittedBox(
                  child: FaIcon(
                    icon,
                    color: iconColor,
                  ),
                ),
              ),

              SizedBox(height: context.height*0.006,),

              Expanded(
                flex: 3,
                child: FittedBox(
                  child: Text(
                    text,
                    style: textStyle,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


