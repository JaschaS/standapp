import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../standapp_colors.dart';
import 'avatar_widget.dart';

typedef DateCallback = void Function(DateTime);

class AvatarTile extends StatefulWidget {
  final Avatar avatar;
  final Widget? title;
  final DateTime? start;
  final DateTime? end;

  AvatarTile({this.avatar = const Avatar(), this.title, this.start, this.end});

  @override
  State<StatefulWidget> createState() => _AvatarTileState();
}

class _AvatarTileState extends State<AvatarTile> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    _start = widget.start ?? _generateStartTime();
    _end = widget.end ?? _start.add(Duration(days: 4));

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _banner(),
          widget.avatar,
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
            color: AppColors.gray,
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
                    if (widget.title != null) widget.title!,
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
        _DateButton(_start, (newDate) {
          setState(() {
            _start = newDate;
          });
        }),
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
        _DateButton(_end, (newDate) {
          setState(() {
            _end = newDate;
          });
        }),
      ],
    );
  }

  static DateTime _generateStartTime() {
    final today = DateTime.now();

    switch (today.weekday) {
      case DateTime.monday:
        return today;
      case DateTime.tuesday:
        return today.add(Duration(days: 6));
      case DateTime.wednesday:
        return today.add(Duration(days: 5));
      case DateTime.thursday:
        return today.add(Duration(days: 4));
      case DateTime.friday:
        return today.add(Duration(days: 3));
      case DateTime.saturday:
        return today.add(Duration(days: 2));
      case DateTime.sunday:
        return today.add(Duration(days: 1));
      default:
        return today;
    }
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final DateCallback onDateChange;
  final DateFormat _formatter = DateFormat("MMMM d'th', y");

  _DateButton(this.date, this.onDateChange);

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
        onPressed: () => _onPress(context),
        icon: Icon(
          Icons.date_range,
          size: 24,
        ),
        label: Text(
          _formatter.format(date),
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
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (newDate != null) {
      onDateChange(newDate);
    }
  }
}
