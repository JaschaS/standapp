import 'dart:math';

class AvatarsImages {
  AvatarsImages._();

  static const String anonymous = "images/Anonymous.png";
  static const String ginger_freckles = "images/ginger_freckles.png";

  static List<String> imagesColored = [
    for (var i = 0; i < 21; i += 1)
      if (i != 0 && i != 2) "images/Avatar${i < 10 ? "0$i" : i}.png"
  ];

  static List<String> imagesBlack = [
    for (var i = 0; i < 21; i += 1)
      if (i != 0 && i != 2) "images/Avatar${i < 10 ? "0$i" : i}-1.png"
  ];

  static String randomAvatar() {
    final random = Random();

    final index = random.nextInt(imagesColored.length);

    return random.nextBool() ? imagesColored[index] : imagesBlack[index];
  }

  static String randomBlackAvatar() {
    final random = Random();

    final index = random.nextInt(imagesBlack.length);

    return imagesBlack[index];
  }
}
