import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:standapp/standapp/standapp_colors.dart';

class HomeScreenHeader extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.accessibility,
                  size: 50,
                  color: AppColors.darkBlue,
                ),
                Icon(
                  Icons.accessibility,
                  size: 50,
                  color: AppColors.red,
                ),
                Icon(
                  Icons.accessibility,
                  size: 50,
                  color: AppColors.lightGray,
                )
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text("STANDUP-Host",
                  style: GoogleFonts.bungee(
                      textStyle:
                          TextStyle(fontSize: 34, color: AppColors.darkGray))),
            )
          ],
        ),
      ),
    );
  }
}
