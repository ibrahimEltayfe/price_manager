import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_manager/core/constants/app_icons.dart';
import 'package:price_manager/core/constants/app_strings.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';
import 'package:price_manager/features/home/presentation/bloc/product_details/product_details_bloc.dart';
import 'package:price_manager/reusable_components/status_snackbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../reusable_components/outline_border_text_field.dart';
import '../../../../reusable_components/responsive/fractionally_icon.dart';
import '../../../../reusable_components/responsive/fractionally_text.dart';
import '../widgets/build_network_image.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController descController = TextEditingController();
  late final TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(mounted){
      final product = context.read<ProductDetailsBloc>().product;

      nameController.value = TextEditingValue(text: product.name ?? '555');
      descController.value = TextEditingValue(text: product.desc ?? '');
      priceController.value = TextEditingValue(text: product.price ?? '');

      context.read<ProductDetailsBloc>().imagePickerHelper.imagePickerController.stream.listen(
          (value){
            log(value.toString());
            if(value == product.image){
              context.read<ProductDetailsBloc>().buttonStateController.sink.add(false);
            }else{
              context.read<ProductDetailsBloc>().buttonStateController.sink.add(true);
            }
          }
      );

    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,

      body: Form(
        key: _formKey,
        onChanged: () {
          final product = context.read<ProductDetailsBloc>().product;
          //final image = context.read<ProductDetailsBloc>().imagePickerHelper.image;

          if(nameController.text == product.name
           && descController.text == product.desc
           && priceController.text == product.price
          ){
            context.read<ProductDetailsBloc>().buttonStateController.sink.add(false);
          }else{
            context.read<ProductDetailsBloc>().buttonStateController.sink.add(true);
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              //image
               const _BuildProductImage(),
              
              //edit image action buttons
              Positioned(
                right: context.width*0.02,
                top: context.height*0.24,
                child: _BuildImageActionButton(
                  onTap:() async{
                    await context.read<ProductDetailsBloc>().imagePickerHelper.pickImageFromGallery();
                  },
                  icon: AppIcons.edit,
                  text: 'تعديل الصورة',
                  color: AppColors.black,
                ),
              ),

              //delete image action buttons
              Positioned(
                right: context.width*0.02,
                top: context.height*0.3,
                child: _BuildImageActionButton(
                  onTap:(){
                    context.read<ProductDetailsBloc>().imagePickerHelper.removeImage();
                  },
                  icon: AppIcons.delete,
                  text: 'حذف الصورة',
                  color: AppColors.darkRed,
                ),
              ),

              _BottomSheet(
                nameController:nameController ,
                descController:descController ,
                priceController:priceController ,
                formKey: _formKey,
              ),

              //return button
              Positioned(
                left: context.width*0.018,
                top: context.height*0.018,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: context.width*0.12,
                    height: context.height*0.056,
                    decoration: getContainerDecoration(
                      offset: Offset(0,context.height*0.003),
                      borderRadius: 15
                    ),
                    child: FractionallyIcon(
                      heightFactor: 0.42,
                      widthFactor: 0.42,
                      color: AppColors.black,
                      icon: AppIcons.arrowLeft,
                    ),
                  ),
                )
              )
              

            ],
          ),
        ),
      ),
    );

  }
}

class _BuildProductImage extends StatelessWidget {
  const _BuildProductImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.height*0.05,

      child: SizedBox(
        height: context.height * 0.265,
        width: context.width,
        child: StreamBuilder<String>(
            stream: context.read<ProductDetailsBloc>().imagePickerHelper.imagePickerController.stream,
            builder: (context,AsyncSnapshot<String> snapshot) {

              final String image = context.read<ProductDetailsBloc>().imagePickerHelper.image;
              final bool isNetwork = context.read<ProductDetailsBloc>().imagePickerHelper.isNetworkImage;

              if(snapshot.hasError){
                Fluttertoast.showToast(msg: snapshot.error.toString());
              }

              if(image.isEmpty){
                return const FractionallyIcon(
                    heightFactor: 0.5,
                    widthFactor: 0.5,
                    icon: FontAwesomeIcons.image,
                    color: AppColors.darkBlue
                );
              }

              if(isNetwork){
                return BuildNetworkImage(image);
              }else{
                return FittedBox(
                  child: Image.file(File(image)),
                );
              }

            }
        ),
      ),
    );
  }
}

class _BuildImageActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;
  final IconData icon;
  const _BuildImageActionButton({Key? key, required this.onTap, required this.text, required this.icon, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width*0.28,
        height: context.height*0.045,
        decoration: getOutlineBorderedDecoration(
          borderRadius: 25,
        ),
        child: Row(
          children: [
            SizedBox(width: context.width*0.03,),
            Expanded(
              flex: 5,
              child: FittedBox(
                child: Text(text,style: getBoldTextStyle(color: color),),
              )
            ),

            SizedBox(width: context.width*0.015,),
            Expanded(
              flex: 1,
              child: FittedBox(child: FaIcon(icon,color: color,))
            ),

            SizedBox(width: context.width*0.03,),
          ],
        )
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController priceController;
  final GlobalKey<FormState> formKey;

  const _BottomSheet({Key? key, required this.nameController, required this.descController, required this.priceController, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: context.width,
        height: context.height * 0.61,
        decoration: getContainerDecoration(
          offset: Offset(0,-context.height*0.001),
          borderRadius: 25,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: context.width*0.03,
              vertical: context.height*0.05
          ),
          children: [
            OutlineBorderTextField(
              controller: nameController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'هذا الحقل مطلوب';
                }

                return null;
              },
              hint: AppStrings.productName,
              textInputType: TextInputType.text,
            ),

            SizedBox(height: context.height*0.03,),
            OutlineBorderTextField(
              controller: descController,
              validator: (value) {
                return null;
              },
              hint: AppStrings.desc,
              textInputType: TextInputType.text,
            ),

            SizedBox(height: context.height*0.03,),
            OutlineBorderTextField(
              controller: priceController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'هذا الحقل مطلوب';
                }

                return null;
              },
              hint: AppStrings.price,
              textInputType: TextInputType.number,
            ),

            SizedBox(height: context.height*0.04,),

            StreamBuilder<String?>(
              stream: context.read<ProductDetailsBloc>().productDateInfoController.stream,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                }

                if(snapshot.data == null){
                  return const SizedBox.shrink();
                }

                return AutoSizeText(
                  snapshot.data??'',
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  minFontSize: 16,
                  maxFontSize: 16,
                  style: getBoldTextStyle(fontWeight: FontWeight.w400),
                );
              }
            ),

            SizedBox(height: context.height*0.02,),

            _EditButton(
                onTap: (){
                  if(formKey.currentState!.validate()){
                    final ProductEntity product = context.read<ProductDetailsBloc>().product;

                    product.name = nameController.text;
                    product.desc = descController.text;
                    product.price = priceController.text;

                    context.read<ProductDetailsBloc>().add(UpdateProductDetailsEvent(product));
                  }
                }),


            SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)

          ],
        ),
      ),
    );
  }

}

class _EditButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EditButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
    stream: context.read<ProductDetailsBloc>().buttonStateController.stream,
     builder:(context, AsyncSnapshot<bool> snapshot) {
       final bool isActive = snapshot.data ?? false;

       return  BlocConsumer<ProductDetailsBloc,ProductDetailsState>(
         listener: (context, state) async{
           if(state is ProductDetailsUpdated){
             statusSnackBar(
               context: context,
               text: "تم التعديل",
             );
           }else if(state is ProductDetailsError){
             statusSnackBar(
                 context: context,
                 text: state.message,
                 isError: true
             );
           }
         },

         builder: (context, state) {
           return GestureDetector(
             onTap: onTap,
             child: Container(
                 width: context.width*0.6,
                 height: context.height*0.09,
                 decoration: getContainerDecoration(
                     offset: Offset(0, context.height*0.008),
                     borderRadius: 20,
                     bgColor: isActive?AppColors.darkBlue:AppColors.darkGrey
                 ),
                 child: state is ProductDetailsLoading
                     ? const Center(child: CircularProgressIndicator(color: AppColors.white,),)
                     : FractionallyText(
                     widthFactor:0.7 ,
                     heightFactor:0.7 ,
                     text: "تعديل",
                     textStyle: getBoldTextStyle(color:AppColors.backgroundColor),
                     alignment: Alignment.center
                 )
             ),
           );
         },
       );
     }

    );
  }
}

