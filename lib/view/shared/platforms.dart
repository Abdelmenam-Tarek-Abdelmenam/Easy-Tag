import 'package:flutter/foundation.dart';

class Platform {
  static Future<void> execute({
    required Function mobile,
    required Function web,
  }) async {
    if (kIsWeb) {
      await web();
    } else {
      await mobile();
    }
  }
}
