import 'package:flutter/material.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/reusable_components/responsive/fittted_text.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_styles.dart';

class AuthTextField extends StatefulWidget {
  final String hint;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final IconData icon;

  const AuthTextField({
    required this.hint,
    this.textInputType,
    this.textInputAction,
    required this.validator,
    Key? key, required this.controller, required this.icon,
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.9,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGrey,
                    blurRadius: 0.015*size.width,
                    offset: Offset(0,0.0072*size.width),
                  )
                ]
            ),
            child: TextFormField(
              validator:(value){
                setState(() {
                  errorMessage = widget.validator(value);
                });

                return errorMessage;
              },

              controller: widget.controller,
              style: getRegularTextStyle(fontSize: size.width*0.045,fontWeight: FontWeight.w600),
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              textAlign: TextAlign.right,

              decoration: InputDecoration(
                isDense: true,
                hintText:widget.hint,
                contentPadding: EdgeInsets.symmetric(
                    vertical: size.height*0.021,
                    horizontal: size.width*0.025
                ),

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.036*size.width),
                    borderSide: BorderSide.none
                ),

                errorStyle: const TextStyle(fontSize: 0,height: 1),

                suffixIcon: FittedBox(child: Icon(widget.icon,color: AppColors.primaryColor,)),
                suffixIconConstraints: BoxConstraints.tightFor(height:size.height*0.033,width:size.width*0.132),

                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),

          if(errorMessage != null)
           Align(
             alignment: Alignment.centerRight,
             child: Padding(
               padding: EdgeInsets.only(right: context.width*0.035,top: context.height*0.008),
               child: FittedText(
                 height: context.height*0.028,
                 width: context.width*0.6,
                 alignment: Alignment.centerRight,
                 text:errorMessage!,
                 textStyle: getRegularTextStyle(color: AppColors.darkRed
                 ),
               ),
             ),
           )

        ],
      ),
    );
  }
}
