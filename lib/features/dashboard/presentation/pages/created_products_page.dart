import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../reusable_components/products_gridview.dart';
import '../bloc/admin_created_products/created_products_bloc.dart';
import '../widgets/show_products_button.dart';

class AdminAddedProducts extends StatelessWidget {
  AdminAddedProducts({Key? key}) : super(key: key);

  final ValueNotifier valueNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder:(context, isShowProducts, child) {
          if(isShowProducts){
            return BlocBuilder<CreatedProductsBloc,CreatedProductsState>(
              builder: (context, state) {
                return ProductsGridView(
                  onProductTap: (index) {
                    Navigator.pushNamed(
                        context,
                        AppRoutes.productDetailsRoute,
                        arguments: context.read<CreatedProductsBloc>().products[index]
                    );
                  },
                  isFirstFetch:context.read<CreatedProductsBloc>().isFirstFetch,
                  products: context.read<CreatedProductsBloc>().products,
                  errorMessage:(state is CreatedProductsError)?state.message:'',

                  dataFetchedState: state is CreatedProductsDataFetched,
                  errorState: state is CreatedProductsError,
                  loadingState: state is CreatedProductsLoading,

                  onNotification: (scrollNotification){
                    return context.read<CreatedProductsBloc>().handleScrollPagination(
                      scrollNotification:scrollNotification,
                      subtractedTriggerHeight:context.height*0.1,
                    );
                  },
                );
              },
            );
          }else{
            return ShowProductsButton(
              onTap: (){
                valueNotifier.value = true;
                context.read<CreatedProductsBloc>().add(const LoadCreatedProductsEvent());
              },
              title: AppStrings.clickToShowAddedProducts,
            );
          }
        },
    );


  }
}

