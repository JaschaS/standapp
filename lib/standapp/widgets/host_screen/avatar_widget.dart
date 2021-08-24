import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_avatars.dart';

class Avatar extends StatelessWidget {
  final String _image;

  const Avatar({String image = AvatarsImages.anonymous})
      : _image = image,
        super(key: const Key("Avatar"));

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image(
        image: AssetImage(_image),
        fit: BoxFit.cover,
      ),
    );
  }
}
