import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_manager/core/constants/app_colors.dart';
import 'package:price_manager/core/constants/app_styles.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/reusable_components/responsive/fractionally_icon.dart';
import 'package:price_manager/reusable_components/responsive/fractionally_text.dart';
import 'package:price_manager/reusable_components/outline_border_text_field.dart';
import 'package:price_manager/reusable_components/status_snackbar.dart';

import '../bloc/add_product/add_product_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController descController = TextEditingController();
  late final TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        elevation: 4,
        shadowColor: AppColors.shadowColor,
        iconTheme:const IconThemeData(color: AppColors.black) ,
        title: FittedBox(
         child: Text("إضافة منتج",style: getBoldTextStyle(),),
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: context.height*0.03,),
                  _BuildImagePicker(),

                  SizedBox(height: context.height*0.03,),
                  OutlineBorderTextField(
                      hint: ": "'الاسم',
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                      controller: nameController,
                  ),

                  SizedBox(height: context.height*0.02,),
                  OutlineBorderTextField(
                    hint:  ": "'التفاصيل',
                    validator: (value){
                      return null;
                    },
                    controller: descController,
                  ),

                  SizedBox(height: context.height*0.02,),
                  OutlineBorderTextField(
                    hint: ": "'السعر',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "هذا الحقل مطلوب";
                      }
                      return null;
                    },
                    controller: priceController,
                  ),

                  SizedBox(height: context.height*0.04,),
                  _AddButton(
                    onTap:(){
                      if(_formKey.currentState!.validate()){
                        context.read<AddProductBloc>().add(SaveProductEvent(
                            name: nameController.text,
                            desc: descController.text,
                            price: priceController.text
                        ));
                      }
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildImagePicker extends StatelessWidget {
  const _BuildImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await context.read<AddProductBloc>().imagePickerHelper.pickImageFromGallery();
      },
      child: Container(
        width: context.width*0.54,
        height: context.height*0.22,
        decoration: getOutlineBorderedDecoration(borderColor: AppColors.mediumGrey),

        child: StreamBuilder<String>(
          stream: context.read<AddProductBloc>().imagePickerHelper.imagePickerController.stream,
          builder: (context,AsyncSnapshot<String> snapshot) {
            final String? image = context.read<AddProductBloc>().imagePickerHelper.image;

            if(snapshot.hasError){
              Fluttertoast.showToast(msg: snapshot.error.toString());
            }

            if(image == null || image.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: context.height*0.05,),

                  const Expanded(
                    child: FractionallyIcon(
                        heightFactor: 0.65,
                        widthFactor: 0.75,
                        icon: FontAwesomeIcons.image,
                        color: AppColors.darkBlue
                    ),
                  ),

                  Expanded(
                    child: FractionallyText(
                      heightFactor: 0.58,
                      widthFactor: 0.7,
                      text: 'اضافة صورة',
                      textStyle: getBoldTextStyle(color: AppColors.darkBlue),
                      alignment: Alignment.center,
                    ),
                  ),

                  SizedBox(height: context.height*0.02,),

                ],
              );
            }

            return FittedBox(
              child: Image.file(File(image)),
            );

          }
        ),

      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({Key? key, required this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AddProductBloc,AddProductState>(
        listener: (context, state) async{
          if(state is AddProductDataSaved){
            statusSnackBar(
                context: context,
                text: "تمت الإضافة",
            );
          }else if(state is AddProductError){
            statusSnackBar(
                context: context,
                text: state.message,
                isError: true
            );
          }
        },

        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: context.width*0.6,
            height: context.height*0.09,
            decoration: getContainerDecoration(
                offset: Offset(0, context.height*0.008),
                borderRadius: 20,
                bgColor: AppColors.darkBlue
            ),
            child: BlocBuilder<AddProductBloc,AddProductState>(

              builder:(context, state){
                if(state is AddProductLoading){
                 return const Center(child: CircularProgressIndicator(color: AppColors.white,),);
                }

                return FractionallyText(
                  widthFactor:0.7 ,
                  heightFactor:0.7 ,
                  text: "إضافة",
                  textStyle: getBoldTextStyle(color:AppColors.backgroundColor),
                  alignment: Alignment.center
                );
               }
              ),
            ),
          ),
    );
  }
}
