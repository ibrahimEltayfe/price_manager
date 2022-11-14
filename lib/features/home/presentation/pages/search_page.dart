import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/constants/app_routes.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';
import 'package:price_manager/features/home/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:price_manager/reusable_components/responsive/fittted_text.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../reusable_components/responsive/fractionally_icon.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.032,
                vertical: context.height*0.032
              ),
              child: Container(
                  width: context.width,
                  height: context.height * 0.07,
                  decoration: getContainerDecoration(
                      offset: Offset(0, context.height * 0.004),
                      borderRadius: 15,
                      blurRadius: 6
                  ),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (v){
                      context.read<SearchBloc>().add(GetSearchResultsEvent(
                          searchController.text
                      ));
                    },
                    onEditingComplete: (){
                      context.read<SearchBloc>().add(GetSearchResultsEvent(
                          searchController.text
                      ));
                    },
                    textInputAction: TextInputAction.done,
                    textAlignVertical: TextAlignVertical.bottom,
                    textAlign: TextAlign.right,
                    cursorRadius: const Radius.circular(10),
                    cursorColor: AppColors.semiBlack,
                    style: getRegularTextStyle(),
                    decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: context.width * 0.05),
                        child: const FractionallyIcon(
                          widthFactor: 0.15,
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
            ),

            _BuildSearchResultsList()

          ],
        ),
      ),
    );
  }
}

class _BuildSearchResultsList extends StatelessWidget {
  const _BuildSearchResultsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc,SearchState>(
      builder:(context, state) {
        if(state is SearchError){
          return _BuildErrorWidget(errorMsg: state.message,);
        }else if(state is SearchLoading){
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
        }else if(state is SearchDataFetched){
          return Expanded(
              child: ListView.builder(
                itemCount: state.searchResults.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.height*0.05),
                    child: SizedBox(
                      height: context.height*0.09,
                      width: context.width*0.95,
                      child: ListTile(
                        onTap: (){
                          Navigator.pushNamed(
                             context,
                             AppRoutes.productDetailsRoute,
                             arguments: state.searchResults[i]
                          );
                        },
                       title: Text(
                         state.searchResults[i].name??'',
                           style: getBoldTextStyle(),
                       ),
                       subtitle: Text(
                         state.searchResults[i].desc??'',
                         style: getRegularTextStyle(),
                       ),
                      ),
                    ),
                  );
                },
              )
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  final String errorMsg;
  const _BuildErrorWidget({Key? key, required this.errorMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedText(
            height: context.height*0.05,
            width: context.width*0.6,
            text: errorMsg,
            textStyle: getBoldTextStyle(color: AppColors.darkRed)
        ),

        //todo:add lottie anim
      ],
    );
  }
}
