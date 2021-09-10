import 'package:flutter/material.dart';

class DefaultTextButton extends StatelessWidget {
  Function function;
  Widget text;

  DefaultTextButton({this.function, this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      child: text,
    );
  }
}
