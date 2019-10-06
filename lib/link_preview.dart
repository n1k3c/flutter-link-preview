import 'dart:async';
import 'dart:convert';

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
      {@required Function(PreviewResponse model) onData,
      @required Function onError}) async {
    return eventChannel
        .receiveBroadcastStream(url)
        .listen(
          (dynamic event) => _mapData(event, onData),
          onError: (dynamic error) => onError(error),
        )
        .asFuture();
  }

  static _mapData(dynamic event, Function(PreviewResponse model) onData) {

    var data = Map<String, dynamic>.from(event);

    PreviewStatus status;

    if (data['state'] == 'loading') {
      status = PreviewStatus.loading;
      PreviewResponse previewModel = PreviewResponse(status);
      onData(previewModel);
    } else {
      status = PreviewStatus.complete;
      PreviewResponse previewModel = PreviewResponse(
        status,
        title: data['title'],
        description: data['description'],
      );
      onData(previewModel);
    }
  }
}

class PreviewResponse {
  final PreviewStatus status;
  final String title;
  final String description;

  PreviewResponse(this.status, {this.title, this.description});
}

enum PreviewStatus {
  loading,
  complete
}
