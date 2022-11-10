import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/utils/injector.dart' as di;
import 'package:price_manager/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:price_manager/features/auth/presentation/pages/decide_page.dart';
import 'package:price_manager/features/auth/presentation/pages/login_page.dart';
import 'package:price_manager/features/dashboard/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:price_manager/features/dashboard/presentation/pages/add_product_page.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';
import 'package:price_manager/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:price_manager/features/home/presentation/bloc/product_details/product_details_bloc.dart';
import 'package:price_manager/features/profile/presentation/pages/change_password_page.dart';
import 'core/constants/app_routes.dart';
import 'features/home/presentation/pages/home_base.dart';
import 'features/home/presentation/pages/product_details.dart';

class RoutesManager{

  static Route<dynamic> routes(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.homePageRoute:
        return MaterialPageRoute(
            builder: (_)=> HomeBase(),
            settings: settings
        );

      case AppRoutes.loginPageRoute:
        return MaterialPageRoute(
            builder: (_)=> BlocProvider(
                create: (_) => di.injector<AuthBloc>(),
                child: LoginPage()
            ),
            settings: settings
        );

      case AppRoutes.decidePageRoute:
        return MaterialPageRoute(
            builder: (_)=> DecidePage(),
            settings: settings
        );

      case AppRoutes.addProduct:
        return MaterialPageRoute(
            builder: (_)=> BlocProvider(
                create: (_)=>di.injector<AddProductBloc>()..add(InitializeProductEvent()),
                child: AddProductPage()
            ),
            settings: settings
        );

      case AppRoutes.productDetailsRoute:
        return MaterialPageRoute(
            builder: (_)=> BlocProvider<ProductDetailsBloc>(
                create: (_)=>di.injector<ProductDetailsBloc>()
                  ..add(InitializeProductDetailsEvent(settings.arguments as ProductEntity)),
                child: ProductDetailsPage()
            ),
            settings: settings
        );

      case AppRoutes.changePasswordPage:
        return MaterialPageRoute(
            builder: (_)=> ChangePasswordPage(),
            settings: settings
        );

      default: return MaterialPageRoute(
          builder: (_)=> UnExcepectedErrorPage(),
          settings: settings
      );
    }

  }
}

//todo:
class UnExcepectedErrorPage extends StatelessWidget {
  const UnExcepectedErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('UnExcepectedErrorPage'),
      ),
    );
  }
}
