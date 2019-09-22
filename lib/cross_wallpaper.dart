import 'dart:async';

import 'package:flutter/services.dart';

class CrossWallpaper {
  static const MethodChannel _channel =
      const MethodChannel('cross_wallpaper');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
