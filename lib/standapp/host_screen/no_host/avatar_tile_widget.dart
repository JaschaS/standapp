import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../standapp_colors.dart';
import 'avatar_widget.dart';

typedef DateCallback = void Function(DateTime);

class AvatarTile extends StatelessWidget {
  final Avatar avatar;
  final Widget? title;
  final DateTime? start;
  final DateTime? end;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;

  AvatarTile({
    this.start,
    this.end,
    this.title,
    this.onStartChange,
    this.onEndChange,
    Avatar? avatar,
  }) : this.avatar = avatar ?? const Avatar();

  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _banner(),
          this.avatar,
        ],
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
          decoration: BoxDecoration(
            color: AppColors.fifty_shades,
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
                width: 452,
                height: 69,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (this.title != null) this.title!,
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
        const Text(
          "from",
          style: const TextStyle(
            fontSize: 16,
          ),
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
        const Text(
          "until",
          style: const TextStyle(
            fontSize: 16,
          ),
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
      width: 175,
      height: 40,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return AppColors.button_color;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.button_text_disable;
            }
            return Colors.black;
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
          style: TextStyle(fontSize: 16),
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
