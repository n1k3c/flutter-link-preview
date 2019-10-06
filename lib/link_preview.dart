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

  static Future<String> getPreview(String url,
      {@required Function onData, @required Function onError}) async {
    return eventChannel
        .receiveBroadcastStream(url)
        .listen(
          (dynamic event) => onData(event),
          onError: (dynamic error) => onError(error),
        ).asFuture();
  }
}

class LinkPreviewModel {}
