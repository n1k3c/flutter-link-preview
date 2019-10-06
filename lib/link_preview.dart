import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LinkPreview {
  static const MethodChannel _channel = const MethodChannel('link_preview');

  static const EventChannel eventChannel = EventChannel('link_preview_events');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  listenEvents({@required Object event, @required Object error}) {
    eventChannel.receiveBroadcastStream("https://www.coolinarika.com/recept/1094861/").listen((dynamic event) {
      print('Received event: $event');
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, onDone: () {
      print('Stream complete');
    });
  }
}
