import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_manager/core/constants/app_routes.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
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
                  height: context.height * 0.072,

                  decoration: getContainerDecoration(
                      offset: Offset(0, context.height * 0.004),
                      borderRadius: context.width*0.04,
                      blurRadius: 6
                  ),
                  child: TextField(
                    autofocus: true,
                    controller: searchController,
                    onEditingComplete: (){
                      context.read<SearchBloc>().add(GetSearchResultsEvent(
                          searchController.text
                      ));
                    },
                    textInputAction: TextInputAction.done,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.right,
                    cursorRadius: const Radius.circular(10),
                    textDirection: TextDirection.rtl,
                    cursorColor: AppColors.semiBlack,
                    maxLines: 1,

                    style: getRegularTextStyle(fontSize: context.width*0.045,fontWeight: FontWeight.w600),

                    decoration: InputDecoration(
                      contentPadding:EdgeInsets.symmetric(
                         horizontal: context.width*0.013,
                         vertical: context.height*0.02
                      ) ,
                      isDense: true,

                      prefixIcon:GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: context.width * 0.02),
                          child: const FractionallyIcon(
                            widthFactor: 0.07,
                            heightFactor: 0.4,
                            color: AppColors.black,
                            icon: AppIcons.arrowLeft,
                          ),
                        ),
                      ),


                      suffixIcon: GestureDetector(
                        onTap: () {
                          context.read<SearchBloc>().add(GetSearchResultsEvent(
                              searchController.text
                          ));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: context.width * 0.05),
                          child: const FractionallyIcon(
                            widthFactor: 0.07,
                            heightFactor: 0.4,
                            color: AppColors.primaryColor,
                            icon: AppIcons.search,
                          ),
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
                    padding: EdgeInsets.only(bottom: context.height*0.06),
                    child: SizedBox(
                      height: context.height*0.09,
                      width: context.width*0.95,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          trailing: FractionallySizedBox(
                            widthFactor: 0.2,
                            heightFactor: 1,
                            child: AutoSizeText(
                              '${state.searchResults[i].price} جنيه'??'',
                              style: getBoldTextStyle(color: AppColors.primaryColor),

                            ),
                          ),
                          onTap: (){
                            Navigator.pushNamed(
                               context,
                               AppRoutes.productDetailsRoute,
                               arguments: state.searchResults[i]
                            );
                          },
                         title: FractionallySizedBox(
                           widthFactor: 1,
                           heightFactor: 0.58,
                           child: AutoSizeText(
                             state.searchResults[i].name??'',
                               style: getBoldTextStyle(),

                           ),
                         ),
                         subtitle: FractionallySizedBox(
                           widthFactor: 1,
                           heightFactor: 0.58,
                           child: AutoSizeText(
                             state.searchResults[i].desc??'',
                             style: getRegularTextStyle(),
                           ),
                         ),
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
