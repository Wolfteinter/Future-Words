import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff818181, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff8E8E8E), //10%
      100: const Color(0xff9B9B9B), //20%
      200: const Color(0xffA8A8A8), //30%
      300: const Color(0xffB5B5B5), //40%
      400: const Color(0xffC2C2C2), //50%
      500: const Color(0xffCFCFCF), //60%
      600: const Color(0xffDCDCDC), //70%
      700: const Color(0xffE9E9E9), //80%
      800: const Color(0xffF6F6F6), //90%
      900: const Color(0xffFFFFFF), //100%
    },
  );
  static const Color second = Color.fromRGBO(89, 139, 186, 1);
}
