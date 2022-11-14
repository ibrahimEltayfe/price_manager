import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../reusable_components/products_gridview.dart';
import '../bloc/admin_modified_products/modified_products_bloc.dart';
import '../widgets/show_products_button.dart';

class AdminModifiedProducts extends StatelessWidget {
  AdminModifiedProducts({Key? key}) : super(key: key);

  final ValueNotifier valueNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
     valueListenable: valueNotifier,
     builder:(context, isShowProducts, child){
       if(isShowProducts){

         return BlocBuilder<ModifiedProductsBloc,ModifiedProductsState>(
           builder: (context, state) {
             return ProductsGridView(
               onRefresh: ()async{
                 context.read<ModifiedProductsBloc>().refresh();
               },
               onLongPress: (_,i){},
               onProductTap: (index) {
                   Navigator.pushNamed(
                       context,
                       AppRoutes.productDetailsRoute,
                       arguments: context.read<ModifiedProductsBloc>().products[index]
                   );
                 },
                 isFirstFetch:context.read<ModifiedProductsBloc>().isFirstFetch,
                 products: context.read<ModifiedProductsBloc>().products,
                 errorMessage:(state is ModifiedProductsError)?state.message:'',

                 dataFetchedState: state is ModifiedProductsDataFetched,
                 errorState: state is ModifiedProductsError,
                 loadingState: state is ModifiedProductsLoading,

                 onNotification: (scrollNotification){
                   return context.read<ModifiedProductsBloc>().handleScrollPagination(
                     scrollNotification:scrollNotification,
                     subtractedTriggerHeight:context.height*0.1,
                   );
                 },
               );
           },
         );

       }
       else{
         return ShowProductsButton(
           onTap: (){
             valueNotifier.value = true;
             context.read<ModifiedProductsBloc>().add(const LoadModifiedProductsEvent());
           },
           title: AppStrings.clickToShowModifiedProducts,
         );
       }
     });

  }
}
