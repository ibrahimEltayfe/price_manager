import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_styles.dart';
import 'package:price_manager/core/extensions/mediaquery_size.dart';
import 'package:price_manager/reusable_components/responsive/fittted_text.dart';
import '../../../../../../core/constants/app_colors.dart';

class OutlineBorderTextField extends StatefulWidget {
  final String hint;
  final TextInputType? textInputType;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final bool isNormalHint;
  final bool isObscure;

  const OutlineBorderTextField({
    Key? key,
    required this.hint,
    this.textInputType = TextInputType.text,
    required this.validator,
    required this.controller,
    this.isNormalHint = false,
    this.isObscure = false,
  }) : super(key: key);

  @override
  State<OutlineBorderTextField> createState() => _OutlineBorderTextFieldState();
}

class _OutlineBorderTextFieldState extends State<OutlineBorderTextField> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.9,
      child: Column(
        children: [
          Container(
            decoration: getOutlineBorderedDecoration(),
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
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              textAlign:TextAlign.right,
              cursorColor: AppColors.primaryColor,
              cursorRadius: const Radius.circular(20),
              obscureText: widget.isObscure,

              decoration: InputDecoration(
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,

                  hintText: widget.isNormalHint? widget.hint : null,

                  suffixIcon: widget.isNormalHint
                  ?null
                  :Padding(
                    padding: EdgeInsets.only(right: context.width*0.025),
                    child: AutoSizeText(
                      widget.hint,
                      style: getBoldTextStyle(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      maxFontSize: 18,
                    ),
                  ),

                 suffixIconConstraints: BoxConstraints.tightFor(height: context.height*0.037),

                  contentPadding: EdgeInsets.symmetric(
                    vertical: size.height*0.021,
                    horizontal: size.width*0.026
                ),

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.036*size.width),
                    borderSide: BorderSide.none
                ),

                errorStyle: const TextStyle(fontSize: 0,height: 1),

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

