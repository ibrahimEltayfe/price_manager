import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/home/data/models/product_model.dart';
import 'package:price_manager/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:price_manager/reusable_components/responsive/fitted_icon.dart';
import 'package:price_manager/reusable_components/products_gridview.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../reusable_components/responsive/fractionally_icon.dart';
import '../../domain/entities/product_entity.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
   return Column(children: [
     SizedBox(height: context.height * 0.022,),

    _SearchBar(),

     SizedBox(height: context.height * 0.012,),

    Expanded(
    child: BlocBuilder<HomeBloc,HomeState>(
      builder: (context, state) {
        return ProductsGridView(
          onProductTap: (index) {
            Navigator.pushNamed(
                context,
                AppRoutes.productDetailsRoute,
                arguments: context.read<HomeBloc>().products[index]
            );
          },
          onNotification: (scrollNotification) {
            return context.read<HomeBloc>().handleScrollPagination(
                scrollNotification,
                context.height*0.1
            );
          },
          products: context.read<HomeBloc>().products,
          errorMessage:(state is HomeError)?state.message:'',
          isFirstFetch:context.read<HomeBloc>().isFirstFetch,
          dataFetchedState: state is HomeDataFetched,
          errorState: state is HomeError,
          loadingState: state is HomeLoading,
        );
      })
    )

    ]);
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.032),
      child: Container(
          width: context.width,
          height: context.height * 0.07,

          decoration: getContainerDecoration(
              offset: Offset(0, context.height * 0.004),
              borderRadius: 15,
              blurRadius: 6
          ),

          child: TextField(
            textInputAction: TextInputAction.done,
            textAlignVertical: TextAlignVertical.bottom,
            textAlign: TextAlign.right,
            cursorRadius: const Radius.circular(10),
            cursorColor: AppColors.semiBlack,
            style: getRegularTextStyle(),

            decoration: InputDecoration(
              isDense: true,
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: context.width * 0.04),
                child: const FractionallyIcon(
                  widthFactor: 0.1,
                  heightFactor: 0.4,
                  color: AppColors.primaryColor,
                  icon: AppIcons.search,
                ),
              ),

              hintText: AppStrings.search,
              filled: false,
              enabledBorder: getTextFieldRadiusBorder(),
              border: getTextFieldRadiusBorder(),
            ),
          )),
    );
  }
}


