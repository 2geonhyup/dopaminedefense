import 'package:flutter/material.dart';

import '../constants.dart';

class NavigateButton extends StatelessWidget {
  final void Function()? onPressed;
  final double width;
  final double height;
  final String text;
  final Color foregroundColor;
  final Color backgroundColor;
  const NavigateButton(
      {Key? key,
      required this.onPressed,
      this.width = 200,
      this.height = 70,
      required this.text,
      required this.foregroundColor,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            style: buttonTextStyle.copyWith(color: foregroundColor),
          ),
        ),
        style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90))),
      ),
    );
  }
}
