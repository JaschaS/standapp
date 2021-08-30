import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../standapp_colors.dart';
import '../../standapp_fonts.dart';
import 'avatar_widget.dart';

typedef DateCallback = void Function(DateTime);

class AvatarTile extends StatelessWidget {
  final Avatar avatar;
  final Widget? title;
  final Widget? description;
  final DateTime? start;
  final DateTime? end;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;
  final Widget? primary;
  final Widget? secondary;
  final Widget? alternate;

  const AvatarTile({
    this.start,
    this.end,
    this.title,
    this.description,
    this.onStartChange,
    this.onEndChange,
    Avatar? avatar,
    this.primary,
    this.secondary,
    this.alternate,
  })  : avatar = avatar ?? const Avatar(),
        super(key: const Key("AvatarTile"));

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 870) return _createWeb();
      if (constraints.maxWidth > 615) return _createTablet();

      return _createMobile();
    });
  }

  Widget _createWeb() {
    return SizedBox(
      width: 826,
      height: 270,
      child: Column(
        children: [
          _AvatarTitle(
            height: 34,
            title: title,
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _WebBanner(
                description: description,
                start: start,
                end: end,
                onStartChange: onStartChange,
                onEndChange: onEndChange,
              ),
              avatar,
            ],
          ),
          _buttonBar(padding: const EdgeInsets.only(left: 250)),
        ],
      ),
    );
  }

  Widget _createTablet() {
    return SizedBox(
      height: 346,
      width: 585,
      child: Column(
        children: [
          _AvatarTitle(
            title: title,
            height: 55,
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _TabletBanner(
                description: description,
                start: start,
                end: end,
                onStartChange: onStartChange,
                onEndChange: onEndChange,
              ),
              avatar,
            ],
          ),
          _buttonBar(
            padding: const EdgeInsets.only(top: 49, left: 14),
          ),
        ],
      ),
    );
  }

  Widget _createMobile() {
    return Column(
      children: [
        avatar,
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: title,
        ),
        if (description == null) const SizedBox(height: 20),
        _MobileBanner(
          description: description,
          start: start,
          end: end,
          onStartChange: onStartChange,
          onEndChange: onEndChange,
        ),
        const SizedBox(
          height: 49,
        ),
        if (primary != null) primary!,
        const SizedBox(
          height: 12,
        ),
        if (secondary != null) secondary!,
        const SizedBox(
          height: 12,
        ),
        if (alternate != null) alternate!,
      ],
    );
  }

  Widget _buttonBar({final EdgeInsets padding = EdgeInsets.zero}) {
    return Container(
      padding: padding,
      child: Row(
        children: [
          if (primary != null) primary!,
          const SizedBox(
            width: 12,
          ),
          if (secondary != null) secondary!,
          const SizedBox(
            width: 12,
          ),
          if (alternate != null) alternate!,
        ],
      ),
    );
  }
}

class _MobileBanner extends StatelessWidget {
  final Widget? description;
  final DateTime? start;
  final DateTime? end;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;

  const _MobileBanner({
    this.description,
    this.start,
    this.end,
    this.onStartChange,
    this.onEndChange,
  }) : super(key: const Key("MobileBanner"));

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16,
              top: 20,
            ),
            child: description!,
          ),
        _from(),
        const SizedBox(height: 18),
        _until(),
      ],
    );
  }

  Widget _from() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "from",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
        const SizedBox(
          width: 9,
        ),
        _DateButton(
          date: start,
          onDateChange: onStartChange,
        ),
      ],
    );
  }

  Widget _until() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "until",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
        const SizedBox(
          width: 9,
        ),
        _DateButton(
          date: end,
          onDateChange: onEndChange,
        ),
      ],
    );
  }
}

class _AvatarTitle extends StatelessWidget {
  final Widget? title;
  final double height;

  const _AvatarTitle({
    this.title,
    this.height = 214,
  }) : super(key: const Key("AvatarTile"));

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: height,
      padding: const EdgeInsets.only(left: 251),
      child: title,
    );
  }
}

class _TabletBanner extends StatelessWidget {
  final Widget? description;
  final DateTime? start;
  final DateTime? end;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;

  const _TabletBanner({
    this.description,
    this.start,
    this.end,
    this.onStartChange,
    this.onEndChange,
  }) : super(key: const Key("TabletBanner"));

  @override
  Widget build(final BuildContext context) {
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
          child: _bannerContent(),
        )
      ],
    );
  }

  Widget _bannerContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 163),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: description!,
              ),
            _from(),
            const SizedBox(height: 18),
            _until(),
          ],
        ),
      ),
    );
  }

  Widget _from() {
    return Row(
      children: [
        Text(
          "from",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
        const SizedBox(
          width: 9,
        ),
        _DateButton(
          date: start,
          onDateChange: onStartChange,
        ),
      ],
    );
  }

  Widget _until() {
    return Row(
      children: [
        Text(
          "until",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
        const SizedBox(
          width: 9,
        ),
        _DateButton(
          date: end,
          onDateChange: onEndChange,
        ),
      ],
    );
  }
}

class _WebBanner extends StatelessWidget {
  final Widget? description;
  final DateTime? start;
  final DateTime? end;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;

  const _WebBanner({
    this.description,
    this.start,
    this.end,
    this.onStartChange,
    this.onEndChange,
  }) : super(key: const Key("WebBanner"));

  @override
  Widget build(final BuildContext context) {
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
          child: _bannerContent(),
        )
      ],
    );
  }

  Widget _bannerContent() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 69,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 127,
                height: 180,
              ),
              SizedBox(
                width: 560,
                height: 69,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (description != null) description!,
                    const SizedBox(
                      height: 10,
                    ),
                    _subtitle(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subtitle() {
    return Row(
      children: [
        Text(
          "from",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
        const SizedBox(
          width: 9,
        ),
        _DateButton(
          date: start,
          onDateChange: onStartChange,
        ),
        const SizedBox(
          width: 18,
        ),
        Text(
          "until",
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
        const SizedBox(
          width: 9,
        ),
        _DateButton(
          date: end,
          onDateChange: onEndChange,
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime _date;
  final DateCallback? onDateChange;
  final DateFormat _formatter = DateFormat("MMMM d'th', y");

  _DateButton({
    DateTime? date,
    this.onDateChange,
  }) : _date = date ?? DateTime.now();

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 225,
      height: 40,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return AppColors.fiftyShades;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.audiGrey;
            }
            return AppColors.standardBlue;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: onDateChange != null ? () => _onPress(context) : null,
        icon: const Icon(
          Icons.date_range,
          size: 24,
        ),
        label: Text(
          _formatter.format(_date),
          style: AppFonts.textStyleWithSize(AppFonts.h5),
        ),
      ),
    );
  }

  void _onPress(final BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            primaryColor: AppColors.red,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (newDate != null && onDateChange != null) {
      onDateChange!(newDate);
    }
  }
}
