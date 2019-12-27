import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_preview/link_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _linkTitle = 'Unknown';

  @override
  void initState() {
    super.initState();

    getLinks();
  }

  Future<void> getLinks() async {
    try {
      PreviewResponse previewResponse = await LinkPreview.getData('https://google.com');
      _previewData(previewResponse);

      PreviewResponse previewResponse2 = await LinkPreview.getData('https://facebook.com');
      _previewData(previewResponse2);

      PreviewResponse previewResponse3 = await LinkPreview.getData('https://amazon.com');
      _previewData(previewResponse3);
    } on PlatformException {
      print('Error occured!!');
    }
  }

  _previewData(PreviewResponse previewResponse) {
    if (previewResponse.status == PreviewStatus.success) {
      _linkTitle = previewResponse.title;
      print('===============================================');
      print('Received status: ${previewResponse.status}');
      print('Received title: ${previewResponse.title}');
      print('Received description: ${previewResponse.description}');
      print('Received image: ${previewResponse.image}');
      print('Received url: ${previewResponse.url}');
      print('Received final url: ${previewResponse.finalUrl}');
      print('Received cannonical url: ${previewResponse.cannonicalUrl}');
      print('Received html code: ${previewResponse.htmlCode}');
      print('Received row: ${previewResponse.row}');
      print('===============================================');
    } else {
      print('===============================================');
      print('Received status: ${previewResponse.status}');
      print('===============================================');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Link preview example app'),
        ),
        body: Center(
          child: Text('$_linkTitle\n'),
        ),
      ),
    );
  }
}
