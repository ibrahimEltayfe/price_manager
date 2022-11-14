import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../reusable_components/dialogs/show_menu.dart';
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
            return BlocConsumer<CreatedProductsBloc,CreatedProductsState>(
              listener:(context, state) {
                if(state is ProductDeleted){
                  Fluttertoast.showToast(
                      msg: 'تم الحذف',
                      backgroundColor: AppColors.green,
                      textColor: AppColors.backgroundColor
                  );
                }else if(state is ProductDeletedError){
                  Fluttertoast.showToast(
                      msg: state.message,
                      backgroundColor: AppColors.darkRed,
                      textColor: AppColors.backgroundColor
                  );
                }
              },
              builder: (context, state) {
                return StreamBuilder(
                  stream: context.read<CreatedProductsBloc>().productsController.stream,
                  builder: (context, snapshot) {
                    final List<ProductEntity> products;
                    if(snapshot.data == null){
                      products = context.read<CreatedProductsBloc>().products;
                    }else{
                      products = snapshot.data!;
                    }

                    return  ProductsGridView(
                      onRefresh: () async{
                        context.read<CreatedProductsBloc>().refresh();
                      },
                      onLongPress: (globalKey,index){
                        showPopUpMenu(context, globalKey, (i) {
                          if(PopUpMenuItems.values[i]==PopUpMenuItems.delete){
                            context.read<CreatedProductsBloc>().add(
                                DeleteCreatedProductsEvent(index)
                            );
                          }
                        });
                      },
                      onProductTap: (index) {
                        Navigator.pushNamed(
                            context,
                            AppRoutes.productDetailsRoute,
                            arguments: context.read<CreatedProductsBloc>().products[index]
                        );
                      },
                      isFirstFetch:context.read<CreatedProductsBloc>().isFirstFetch,
                      products: products,
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

