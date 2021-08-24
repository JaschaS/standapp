import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget? _child;
  final double _topWeight;
  final double _bottomWeight;

  const BackgroundWidget({
    Widget? child,
    double topWeight = 0.5,
    double bottomWeight = 0.75,
  })  : _child = child,
        _topWeight = topWeight,
        _bottomWeight = bottomWeight,
        super(key: const Key("BackgroundWidget"));

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * _topWeight),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: AppColors.blue,
              height: MediaQuery.of(context).size.height * _bottomWeight),
        ),
        if (_child != null) _child!
      ],
    );
  }
}
