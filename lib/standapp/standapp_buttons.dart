import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'package:standapp/standapp/standapp_fonts.dart';

class PrimaryAppButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;

  PrimaryAppButton({this.callback, this.title});

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 210,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled))
              return AppColors.jascha_red_disable;

            return AppColors.jascha_red;
          }),
        ),
        onPressed: this.callback,
        child: Text(
          this.title ?? "",
          style: AppFonts.textStyleWithSize(AppFonts.h5,
              color: AppColors.weisser_als_weiss),
        ),
      ),
    );
  }
}

class TextAppButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;

  TextAppButton({this.callback, this.title});

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 99,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(primary: Colors.black),
        onPressed: this.callback,
        child: Text(
          this.title ?? "",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
      ),
    );
  }
}
