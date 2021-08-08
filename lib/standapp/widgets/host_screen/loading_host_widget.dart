import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../standapp_colors.dart';

class LoadingHostWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 855) return WebLoadingHostWidget();
      if (constraints.maxWidth > 585) return TabletLoadingHostWidget();

      return MobileLoadingHostWidget();
    });
  }
}

class WebLoadingHostWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.light_grey,
      highlightColor: AppColors.weisser_als_weiss,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 867,
          height: 275,
          child: Column(
            children: [
              _header(),
              Container(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    _banner(),
                    Container(
                      width: 180,
                      height: 180,
                      child: CircleAvatar(
                        backgroundColor: AppColors.light_grey,
                      ),
                    ),
                  ],
                ),
              ),
              _buttonBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 235,
        height: 39,
        decoration: BoxDecoration(
          color: AppColors.light_grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Row(
      children: [
        Container(
          width: 127,
          height: 180,
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.light_grey,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: 699,
          height: 133,
        )
      ],
    );
  }

  Widget _buttonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      child: Row(
        children: [
          Container(
            width: 210,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.light_grey,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabletLoadingHostWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.light_grey,
      highlightColor: AppColors.weisser_als_weiss,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 585,
          height: 429,
          child: Column(
            children: [
              _header(),
              Container(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    _banner(),
                    Container(
                      width: 180,
                      height: 180,
                      child: CircleAvatar(
                        backgroundColor: AppColors.light_grey,
                      ),
                    ),
                  ],
                ),
              ),
              _buttonBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 21),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 210,
        height: 39,
        decoration: BoxDecoration(
          color: AppColors.light_grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Row(
      children: [
        Container(
          width: 90,
          height: 180,
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.light_grey,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: 495,
          height: 180,
        )
      ],
    );
  }

  Widget _buttonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 49, 0, 0),
      child: Row(
        children: [
          Container(
            width: 210,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.light_grey,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MobileLoadingHostWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.light_grey,
      highlightColor: AppColors.weisser_als_weiss,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 210,
          height: 808,
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  backgroundColor: AppColors.light_grey,
                ),
              ),
              _header(),
              _banner(),
              _buttonBar()
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return _template(235, 39, EdgeInsets.only(top: 16));
  }

  Widget _template(
      final double width, final double height, final EdgeInsets padding) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.light_grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Column(
      children: [
        _template(113, 19, EdgeInsets.only(top: 20)),
        _template(218, 40, EdgeInsets.only(top: 16)),
        _template(218, 40, EdgeInsets.only(top: 16)),
      ],
    );
  }

  Widget _buttonBar() {
    return Padding(
      padding: EdgeInsets.only(top: 49),
      child: Column(
        children: [
          _template(210, 56, EdgeInsets.only(top: 16)),
          _template(210, 56, EdgeInsets.only(top: 16)),
          _template(210, 56, EdgeInsets.only(top: 16)),
        ],
      ),
    );
  }
}
