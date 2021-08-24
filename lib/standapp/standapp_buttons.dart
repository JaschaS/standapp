import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'package:standapp/standapp/standapp_fonts.dart';

class PrimaryAppButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;

  const PrimaryAppButton({this.callback, this.title})
      : super(key: const Key("PrimaryAppButton"));

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 210,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.jaschaRedDisable;
            }

            return AppColors.jaschaRed;
          }),
        ),
        onPressed: callback,
        child: Text(
          title ?? "",
          style: AppFonts.textStyleWithSize(AppFonts.h5,
              color: AppColors.weisserAlsWeiss),
        ),
      ),
    );
  }
}

class SecondaryAppButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;

  const SecondaryAppButton({
    this.callback,
    this.title,
  }) : super(key: const Key("SecondaryAppButton"));

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 210,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return AppColors.fiftyShades;
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.weisserAlsWeiss;
            }

            return Colors.black;
          }),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            return AppFonts.textStyleWithSize(AppFonts.h5);
          }),
        ),
        onPressed: callback,
        child: Text(title ?? ""),
      ),
    );
  }
}

class TextAppButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;

  const TextAppButton({
    this.callback,
    this.title,
  }) : super(key: const Key("TextAppButton"));

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 99,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(primary: Colors.black),
        onPressed: callback,
        child: Text(
          title ?? "",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
      ),
    );
  }
}
