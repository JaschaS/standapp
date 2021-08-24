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

  AvatarTile({
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
  }) : this.avatar = avatar ?? const Avatar();

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 855) return _createWeb();
      if (constraints.maxWidth > 585) return _createTablet();

      return _createMobile();
    });
  }

  Widget _createWeb() {
    return Container(
      width: 826,
      height: 270,
      child: Column(
        children: [
          _AvatarTitle(
            height: 34,
            title: this.title,
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _WebBanner(
                description: this.description,
                start: this.start,
                end: this.end,
                onStartChange: this.onStartChange,
                onEndChange: this.onEndChange,
              ),
              this.avatar,
            ],
          ),
          _buttonBar(padding: EdgeInsets.only(left: 250)),
        ],
      ),
    );
  }

  Widget _createTablet() {
    return Container(
      height: 346,
      width: 585,
      child: Column(
        children: [
          _AvatarTitle(
            title: this.title,
            height: 55,
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _TabletBanner(
                description: this.description,
                start: this.start,
                end: this.end,
                onStartChange: this.onStartChange,
                onEndChange: this.onEndChange,
              ),
              this.avatar,
            ],
          ),
          _buttonBar(
              padding: EdgeInsets.only(
            top: 49,
            left: 14,
          )),
        ],
      ),
    );
  }

  Widget _createMobile() {
    return Container(
      child: Column(
        children: [
          this.avatar,
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: this.title,
          ),
          if (this.description == null) const SizedBox(height: 20),
          _MobileBanner(
            description: this.description,
            start: this.start,
            end: this.end,
            onStartChange: this.onStartChange,
            onEndChange: this.onEndChange,
          ),
          const SizedBox(
            height: 49,
          ),
          if (this.primary != null) this.primary!,
          const SizedBox(
            height: 12,
          ),
          if (this.secondary != null) this.secondary!,
          const SizedBox(
            height: 12,
          ),
          if (this.alternate != null) this.alternate!,
        ],
      ),
    );
  }

  Widget _buttonBar({final EdgeInsets padding = EdgeInsets.zero}) {
    return Container(
      padding: padding,
      child: Row(
        children: [
          if (this.primary != null) this.primary!,
          const SizedBox(
            width: 12,
          ),
          if (this.secondary != null) this.secondary!,
          const SizedBox(
            width: 12,
          ),
          if (this.alternate != null) this.alternate!,
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

  _MobileBanner({
    this.description,
    this.start,
    this.end,
    this.onStartChange,
    this.onEndChange,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (this.description != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: 16,
              top: 20,
            ),
            child: this.description!,
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
          date: this.start,
          onDateChange: this.onStartChange,
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
          date: this.end,
          onDateChange: this.onEndChange,
        ),
      ],
    );
  }
}

class _AvatarTitle extends StatelessWidget {
  final Widget? title;
  final double height;

  _AvatarTitle({
    this.title,
    this.height = 214,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: this.height,
      padding: EdgeInsets.only(left: 251),
      child: this.title,
    );
  }
}

class _TabletBanner extends StatelessWidget {
  final Widget? description;
  final DateTime? start;
  final DateTime? end;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;

  _TabletBanner({
    this.description,
    this.start,
    this.end,
    this.onStartChange,
    this.onEndChange,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          height: 180,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.light_grey,
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
      padding: EdgeInsets.only(left: 163),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (this.description != null)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: this.description!,
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
          date: this.start,
          onDateChange: this.onStartChange,
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
          date: this.end,
          onDateChange: this.onEndChange,
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

  _WebBanner({
    this.description,
    this.start,
    this.end,
    this.onStartChange,
    this.onEndChange,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Container(
          width: 127,
          height: 180,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.light_grey,
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
              Container(
                width: 127,
                height: 180,
              ),
              Container(
                width: 560,
                height: 69,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (this.description != null) this.description!,
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
          date: this.start,
          onDateChange: this.onStartChange,
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
          date: this.end,
          onDateChange: this.onEndChange,
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final DateCallback? onDateChange;
  final DateFormat _formatter = DateFormat("MMMM d'th', y");

  _DateButton({DateTime? date, this.onDateChange})
      : this.date = date ?? DateTime.now();

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 225,
      height: 40,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return AppColors.fifty_shades;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.audi_grey;
            }
            return AppColors.standard_blue;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: this.onDateChange != null ? () => _onPress(context) : null,
        icon: Icon(
          Icons.date_range,
          size: 24,
        ),
        label: Text(
          _formatter.format(this.date),
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
            colorScheme: ColorScheme.light(
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
      initialDate: this.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (newDate != null && this.onDateChange != null) {
      this.onDateChange!(newDate);
    }
  }
}
