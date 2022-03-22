import 'package:black_cat_lib/black_cat_lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginButtonWithIcon extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Icon? icon;
  final bool iconIsImage;
  final String? imageIcon;
  final Color? color;

  const LoginButtonWithIcon({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.iconIsImage,
    this.icon,
    this.imageIcon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function(),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        elevation: 50,
        minimumSize: const Size.fromHeight(42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconIsImage)
            ImageIcon(
              AssetImage(imageIcon!),
              color: color ?? Colors.black,
            )
          else
            icon!,
          sizedBox10Wide,
          MyTextWidget(text: text, color: Colors.black),
        ],
      ),
    ).paddingSymmetric(vertical: 8);
  }
}

class LoginButtonNoIcon extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final double? elevation;

  const LoginButtonNoIcon({
    required this.onPressed,
    required this.text,
    this.color,
    this.elevation,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function(),
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 10,
        primary: color,
        minimumSize: const Size.fromHeight(45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextWidget(text: text, fontSize: 18),
        ],
      ),
    ).paddingSymmetric(vertical: 10);
  }
}
