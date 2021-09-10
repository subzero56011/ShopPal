import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({
    this.width = double.infinity,
    this.function,
    this.text,
    this.background = Colors.blue,
    this.isUpper = true,
  });

  final double width;
  final Function function;
  final String text;
  final Color background;
  final bool isUpper;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
