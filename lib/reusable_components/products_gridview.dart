import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/home/presentation/bloc/home/home_bloc.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_styles.dart';
import '../features/home/domain/entities/product_entity.dart';
import '../features/home/presentation/widgets/build_network_image.dart';
import 'responsive/fitted_icon.dart';

class ProductsGridView extends StatelessWidget {
  final String errorMessage;
  final bool errorState;
  final bool loadingState;
  final bool dataFetchedState;
  final bool isFirstFetch;
  final bool Function(ScrollNotification) onNotification;
  final void Function(int) onProductTap;
  final List<ProductEntity> products;

  const ProductsGridView({Key? key,
    required this.errorState,
    required this.loadingState,
    required this.dataFetchedState,
    required this.products,
    required this.errorMessage,
    required this.isFirstFetch,
    required this.onNotification,
    required this.onProductTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //if first fetch
    if (isFirstFetch) {
      if (errorState) {
        return Center(child: Text(errorMessage),);
      } else if (loadingState) {
        return const Center(child: CircularProgressIndicator(
          color: AppColors.darkBlue,
        ),
        );
      }
    }

    //if next fetch
    return Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              return onNotification(scrollNotification);
            },
            child: _BuildGridView(products: products,onProductTap: onProductTap,),
          ),

          if(loadingState)
            Positioned(
                bottom: 0,
                left: context.width * 0.01,
                child: const _BuildLoadingWidget()
            ),

          if(errorState)
            Positioned(
                width: context.width,
                bottom: 0,
                child: Container(
                    alignment: Alignment.center,
                    color: AppColors.backgroundColor,
                    child: _BuildErrorWidget(message: errorMessage,)
                )
            )

        ]);
  }

}
class _BuildGridView extends StatelessWidget {
  final List<ProductEntity> products;
  final void Function(int) onProductTap;
  const _BuildGridView({Key? key, required this.products, required this.onProductTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async{
                context.read<HomeBloc>().reset();
                context.read<HomeBloc>().add(HomeLoadDataEvent());
              },

              color: AppColors.primaryColor,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
               ),
                padding: EdgeInsets.only(
                    right: context.width * 0.032,
                    left: context.width * 0.032,
                    bottom: context.height * 0.13,
                    top: context.height * 0.018
                ),
                //physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: context.width * 0.042,
                    mainAxisSpacing: context.height * 0.028,
                    childAspectRatio: 0.72
                ),

                itemCount: products.length,

                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: (){
                      onProductTap(i);
                    },
                    child: Container(
                      decoration: getContainerDecoration(offset: Offset(0, context.height * 0.001)),
                      child: Column(
                        children: [

                          _BuildProductImage(
                              image:products[i].image ?? ''
                          ),

                          _BuildAutoSizeText(
                            title: products[i].name ?? '',
                            textStyle: getBoldTextStyle(),
                            fontSize: 15,
                          ),

                          _BuildAutoSizeText(
                            title: products[i].desc ?? '',
                            textStyle:
                            getRegularTextStyle(color: AppColors.darkGrey),
                            fontSize: 14,
                          ),

                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: context.width * 0.025),
                                child: AutoSizeText.rich(
                                  TextSpan(
                                      text: "${products[i].price ?? '...'} ",
                                      children: const [TextSpan(text: 'جنيه')]),
                                  style: getBoldTextStyle(
                                      color: AppColors.primaryColor),
                                  maxLines: 1,
                                  minFontSize: 17,
                                  maxFontSize: 17,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _BuildAutoSizeText extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final double fontSize;
  final Alignment? alignment;
  final int? maxLines;

  const _BuildAutoSizeText(
      {Key? key,
        this.maxLines,
        this.alignment,
        required this.title,
        required this.textStyle,
        required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.01),
      child: Align(
        alignment: alignment??Alignment.centerRight,
        child: AutoSizeText(
          title,
          style: textStyle,
          maxLines: maxLines ?? 1,
          minFontSize: fontSize,
          maxFontSize: fontSize,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

class _BuildProductImage extends StatelessWidget {
  final String image;
  const _BuildProductImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.13,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          child: BuildNetworkImage(image),
        )
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  final String message;

  const _BuildErrorWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: AutoSizeText(
            message,
            style: getBoldTextStyle(color: AppColors.darkRed),
            maxLines: 2,
            minFontSize: 15,
            maxFontSize: 15,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
        ),

        SizedBox(
          width: context.width * 0.01,
        ),

        GestureDetector(
            onTap: (){
              context.read<HomeBloc>().add(HomeLoadDataEvent());
            },
            child: Align(
              alignment: Alignment.center,
              child: FittedIcon(
                height: context.height * 0.06,
                color: AppColors.black,
                width: context.width * 0.06,
                icon: Icons.refresh,
              ),
            )),

        SizedBox(
          width: context.width * 0.015,
        ),
      ],
    );
  }
}

class _BuildLoadingWidget extends StatelessWidget {
  const _BuildLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.height*0.048,
        width: context.width*0.048,
        child: const FittedBox(
          child: CircularProgressIndicator(
            color: AppColors.darkBlue,
          ),
        ));
  }
}
