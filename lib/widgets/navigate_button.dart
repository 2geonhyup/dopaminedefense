import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../constants.dart';

class NavigateButton extends StatelessWidget {
  final void Function()? onPressed;
  final double width;
  final double height;
  final String text;
  final Color foregroundColor;
  final Color backgroundColor;
  final Widget? icon;
  const NavigateButton(
      {Key? key,
      required this.onPressed,
      this.width = 342,
      this.height = 60,
      required this.text,
      this.foregroundColor = Colors.white,
      this.backgroundColor = orangePoint,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: semiBoldWhite20.copyWith(
                      letterSpacing: 0.04, color: foregroundColor)),
              icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: icon,
                    )
                  : SizedBox.shrink()
            ],
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
