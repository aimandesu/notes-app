import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class Utils with ChangeNotifier {
  static final Random _random = Random.secure();

  static String createCryptoStyleString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values).toString();
  }
}
