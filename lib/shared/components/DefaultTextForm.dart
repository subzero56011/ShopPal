import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    this.controller,
    this.label,
    this.onChanged,
    this.onSubmit,
    this.keyboardType,
    this.validate,
    this.prefix,
    this.suffixIcon,
    this.isPassword = false,
    this.suffixPressed,
    this.onTap,
    this.isClickable = true,
    this.searchFocus = false,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final onSubmit;
  final onChanged;
  final Function validate;
  final Function suffixPressed;
  final String label;
  final IconData prefix;
  final IconData suffixIcon;
  final bool isPassword;
  final Function onTap;
  final bool isClickable;
  final bool searchFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: FocusNode(),
      autofocus: searchFocus,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      validator: validate,
      onTap: onTap,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffixIcon))
            : null,
        border: OutlineInputBorder(),
      ),
    );
  }
}
