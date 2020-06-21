import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_Fun/values/values.dart';

class CustomTextFormField extends StatelessWidget {
  final TextStyle textStyle;

  final TextEditingController controller;
  final TextStyle hintTextStyle;
  final TextStyle labelStyle;
  final TextStyle titleStyle;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String hintText;
  final String labelText;
  final String title;
  final bool obscured;
  final bool hasPrefixIcon;
  final bool hasSuffixIcon;
  final bool hasTitle;
  final bool hasTitleIcon;
  final Widget titleIcon;
  final TextInputType textInputType;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final InputBorder border;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final double width;
  final double height;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry textFormFieldMargin;
  final int maxLines;
  final TextInputAction textInputAction;
  final bool autofocus;

  CustomTextFormField(
      {this.textInputAction,
      this.prefixIcon,
      this.maxLines,
      this.controller,
      this.suffixIcon,
      this.textStyle,
      this.hintTextStyle,
      this.labelStyle,
      this.titleStyle,
      this.titleIcon,
      this.hasTitleIcon = false,
      this.title,
      this.contentPadding,
      this.textFormFieldMargin,
      this.hasTitle = false,
      this.border = Borders.primaryInputBorder,
      this.focusedBorder = Borders.focusedBorder,
      this.enabledBorder = Borders.enabledBorder,
      this.hintText,
      this.labelText,
      this.hasPrefixIcon = false,
      this.hasSuffixIcon = false,
      this.obscured = false,
      this.textInputType,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.inputFormatters,
      this.width,
      this.height,
      this.autofocus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            hasTitleIcon ? titleIcon : Container(),
            hasTitle ? Text(title, style: titleStyle) : Container(),
          ],
        ),
//        hasTitle ? SpaceH4() : Container(),
        Container(
          width: width,
          height: height,
          margin: textFormFieldMargin,
          child: TextFormField(
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            onFieldSubmitted: onFieldSubmitted,
            autofocus: autofocus,
            cursorColor: Theme.of(context).accentColor,
            textInputAction: textInputAction,
            maxLines: maxLines,
            style: textStyle,
            controller: controller,
            keyboardType: textInputType,
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              labelText: labelText,
              labelStyle: labelStyle,
              border: border,
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              prefixIcon: hasPrefixIcon ? prefixIcon : null,
              suffixIcon: hasSuffixIcon ? suffixIcon : null,
              hintText: hintText,
              hintStyle: hintTextStyle,
            ),
            obscureText: obscured,
          ),
        ),
      ],
    );
  }
}
