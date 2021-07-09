import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:standapp/standapp/host_screen/date_widget.dart';
import 'package:standapp/standapp/standapp_colors.dart';

class SelectDateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDateWidget> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 867,
        height: 275,
        child: Column(
          children: [
            _AvatarTile(),
          ],
        ),
      ),
    );
  }
}

// Header
// AvatarTile
class _AvatarTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AvatarTileState();
}

class _AvatarTileState extends State<_AvatarTile> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _banner(),
          _Avatar(
            image: "images/Anonymous.png",
          ),
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
              borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    const Text(
                      "Select time",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _date()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _date() {
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
        _dateButton(),
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
        _dateButton(),
      ],
    );
  }

  Widget _dateButton() {
    final DateFormat _formatter =
        DateFormat("MMMM d'th', y"); //DateFormat.yMMMMd('en_US');
    return SizedBox(
      width: 175,
      height: 40,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: null,
        icon: Icon(
          Icons.date_range,
          color: Colors.black,
          size: 24,
        ),
        label: Text(
          _formatter.format(DateTime.now()),
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
// Button bar

class _Avatar extends StatelessWidget {
  final String _image;

  _Avatar({String image = 'images/Avatar20-1.png'}) : this._image = image;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image(
        image: AssetImage(_image),
        fit: BoxFit.cover,
      ),
    );
  }
}
