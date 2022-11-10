import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/constants/app_colors.dart';
import 'package:price_manager/core/constants/app_routes.dart';
import 'package:price_manager/core/constants/app_styles.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/core/utils/injector.dart' as di;
import 'package:price_manager/features/dashboard/presentation/pages/created_products_page.dart';
import 'package:price_manager/features/dashboard/presentation/pages/modified_products_page.dart';
import 'package:price_manager/reusable_components/responsive/fractionally_icon.dart';
import '../bloc/admin_created_products/created_products_bloc.dart';
import '../bloc/admin_modified_products/modified_products_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this,initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context)=> di.injector<CreatedProductsBloc>(),),
        BlocProvider(create:(context)=> di.injector<ModifiedProductsBloc>(),),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            floatingActionButton: _FloatingActionButton(),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  SizedBox(height: context.height*0.005,),
                  Card(
                    elevation: 2,
                    child: SizedBox(
                      width: context.width,
                      height: context.height * 0.08,
                      child: TabBar(
                        controller: tabController,
                        onTap: (index) {
                          tabController.animateTo(index,duration:const Duration(milliseconds: 500),curve: Curves.ease);
                        },

                        labelStyle: getBoldTextStyle(),
                        indicatorColor: AppColors.darkBlue,
                        labelColor: AppColors.darkBlue,

                        unselectedLabelStyle: getBoldTextStyle(),
                        unselectedLabelColor: AppColors.mediumGrey,

                        tabs: [
                          ConstrainedBox(
                           constraints: const BoxConstraints.expand(),
                           child: const Align(
                             alignment: Alignment.center,
                             child: Text("المنتجات المضافة",)
                           )
                         ),

                          ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: const Align(
                                  alignment: Alignment.center,
                                  child: Text('المنتجات المعدلة')
                              )
                          ),
                      ]),
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        AdminAddedProducts(),
                        AdminModifiedProducts()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addProduct);
      },
      backgroundColor: AppColors.primaryColor,

      child: FractionallyIcon(
        widthFactor:0.5 ,
        heightFactor: 0.5,
        color: AppColors.white,
        icon: Icons.add,
      ),
    );
  }
}

