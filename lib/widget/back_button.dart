
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabler_icons/tabler_icons.dart';


class NewBackButton extends StatelessWidget {
  const NewBackButton(
      {super.key,
      this.onTap,
      this.color = Colors.transparent,
      this.iconColor = Colors.black});
  final Function? onTap;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Get.back();
        }
      },
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            color: color,
            shape: BoxShape.circle),
        child: Icon(
          TablerIcons.arrow_left,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }
}
