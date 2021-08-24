import 'dart:math';

class AvatarsImages {
  AvatarsImages._();

  static const String anonymous = "images/Anonymous.png";
  static const String gingerFreckles = "images/ginger_freckles.png";

  static List<String> imagesColored = [
    for (var i = 0; i < 22; i += 1)
      if (i != 0 && i != 2) "images/Avatar${i < 10 ? "0$i" : i}.png"
  ];

  static String randomAvatar() {
    final random = Random();

    final index = random.nextInt(imagesColored.length);

    return imagesColored[index];
  }
}
