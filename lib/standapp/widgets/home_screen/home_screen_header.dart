import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:standapp/standapp/standapp_colors.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader() : super(key: const Key("HomeScreenHeader"));

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 585) {
        return const _Header(
          height: 248,
          fontSize: 34,
          iconSize: 52,
        );
      }

      return const _Header(
        height: 148,
        fontSize: 24,
        iconSize: 42,
      );
    });
  }
}

class _Header extends StatelessWidget {
  final double height;
  final double fontSize;
  final double iconSize;

  const _Header({
    required this.height,
    required this.fontSize,
    required this.iconSize,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.weisserAlsWeiss,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.accessibility,
                size: iconSize,
                color: AppColors.darkBlue,
              ),
              Icon(
                Icons.accessibility,
                size: iconSize,
                color: AppColors.red,
              ),
              Icon(
                Icons.accessibility,
                size: iconSize,
                color: AppColors.lightGray,
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "STANDUP-Host",
              style: GoogleFonts.bungee(
                textStyle: TextStyle(
                  fontSize: fontSize,
                  color: AppColors.darkGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
