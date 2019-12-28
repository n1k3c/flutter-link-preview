import 'dart:async';

import 'package:flutter/services.dart';

class LinkPreview {
  static const MethodChannel _methodChannel =
      MethodChannel('link_preview_channel');

  static Future<PreviewResponse> getPreview(String url) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("url", () => url);

    var result = await _methodChannel.invokeMethod("previewLink", args);
    PreviewResponse previewResponse = _mapResultToResponse(result);
    return previewResponse;
  }

  static PreviewResponse _mapResultToResponse(dynamic result) {
    var data = Map<String, dynamic>.from(result);

    PreviewResponse previewResponse;

    if (data['state'] == 'success') {
      previewResponse = PreviewResponse(
        PreviewStatus.success,
        title: data['title'],
        description: data['description'],
        image: data['image'],
        url: data['url'],
        finalUrl: data['final_url'],
        cannonicalUrl: data['cannonical_url'],
        row: data['row'],
        htmlCode: data['html_code'],
      );
    } else if (data['state'] == 'wrong_url_error') {
      previewResponse = PreviewResponse(PreviewStatus.wrongUrlError);
    } else if (data['state'] == 'parsing_error') {
      previewResponse = PreviewResponse(PreviewStatus.parsingError);
    } else {
      previewResponse = PreviewResponse(PreviewStatus.otherError);
    }

    return previewResponse;
  }
}

class PreviewResponse {
  final PreviewStatus status;
  final String title;
  final String description;
  final String image;
  final String url;
  final String finalUrl;
  final String cannonicalUrl;
  final String row;
  final String htmlCode;

  PreviewResponse(this.status,
      {this.title,
      this.description,
      this.image,
      this.url,
      this.finalUrl,
      this.cannonicalUrl,
      this.row,
      this.htmlCode});
}

enum PreviewStatus { success, wrongUrlError, parsingError, otherError }
