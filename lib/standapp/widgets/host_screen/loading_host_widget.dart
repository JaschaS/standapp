import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../standapp_colors.dart';

class LoadingHostWidget extends StatelessWidget {
  const LoadingHostWidget() : super(key: const Key("LoadingHostWidget"));

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 855) return const WebLoadingHostWidget();
      if (constraints.maxWidth > 585) return const TabletLoadingHostWidget();

      return const MobileLoadingHostWidget();
    });
  }
}

class WebLoadingHostWidget extends StatelessWidget {
  const WebLoadingHostWidget() : super(key: const Key("WebLoadingHostWidget"));

  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.weisserAlsWeiss,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 867,
          height: 275,
          child: Column(
            children: [
              _header(),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  _banner(),
                  const SizedBox(
                    width: 180,
                    height: 180,
                    child: CircleAvatar(
                      backgroundColor: AppColors.lightGrey,
                    ),
                  ),
                ],
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
        decoration: const BoxDecoration(
          color: AppColors.lightGrey,
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
        const SizedBox(
          width: 127,
          height: 180,
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
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
              color: AppColors.lightGrey,
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
  const TabletLoadingHostWidget()
      : super(key: const Key("TabletLoadingHostWidget"));

  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.weisserAlsWeiss,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 585,
          height: 429,
          child: Column(
            children: [
              _header(),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  _banner(),
                  const SizedBox(
                    width: 180,
                    height: 180,
                    child: CircleAvatar(
                      backgroundColor: AppColors.lightGrey,
                    ),
                  ),
                ],
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
        decoration: const BoxDecoration(
          color: AppColors.lightGrey,
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
        const SizedBox(
          width: 90,
          height: 180,
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
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
              color: AppColors.lightGrey,
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
  const MobileLoadingHostWidget()
      : super(key: const Key("MobileLoadingHostWidget"));

  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.weisserAlsWeiss,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 210,
          height: 808,
          child: Column(
            children: [
              const SizedBox(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  backgroundColor: AppColors.lightGrey,
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
    return _template(235, 39, const EdgeInsets.only(top: 16));
  }

  Widget _template(
      final double width, final double height, final EdgeInsets padding) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: AppColors.lightGrey,
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
        _template(113, 19, const EdgeInsets.only(top: 20)),
        _template(218, 40, const EdgeInsets.only(top: 16)),
        _template(218, 40, const EdgeInsets.only(top: 16)),
      ],
    );
  }

  Widget _buttonBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 49),
      child: Column(
        children: [
          _template(210, 56, const EdgeInsets.only(top: 16)),
          _template(210, 56, const EdgeInsets.only(top: 16)),
          _template(210, 56, const EdgeInsets.only(top: 16)),
        ],
      ),
    );
  }
}
