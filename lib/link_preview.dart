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

  Future<String> listenEvents(String url,
      {@required Function onData, @required Function onError}) async {
    // return eventChannel.receiveBroadcastStream(url).listen(onData, onError: onError);

    eventChannel
        .receiveBroadcastStream("https://www.coolinarika.com/recept/1094861/")
        .listen((dynamic event) => _handleData(event),
            onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, onDone: () {
      print('Stream complete');
    });
  }

  _handleData(event) {

  }
}

class LinkPreviewModel {}
