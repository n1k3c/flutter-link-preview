import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:link_preview/link_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  static const EventChannel eventChannel = EventChannel('link_preview_events');

  @override
  void initState() {
    super.initState();
    initPlatformState();

    getLinks();
  }

  Future<void> getLinks() async {
    try {
      await LinkPreview.getPreview('https://www.coolinarika.com/recept/1094861/',
          onData: (data) => _handleData(data),
          onError: (error) => _handleError(error));

      await LinkPreview.getPreview('https://www.coolinarika.com',
          onData: (data) => _handleData(data),
          onError: (error) => _handleError(error));

      await LinkPreview.getPreview('https://www.google.com',
          onData: (data) => _handleData(data),
          onError: (error) => _handleError(error));
    } on PlatformException {
      print('Error occured!!');
    }
  }

  static _handleData(event) {
    print('Received data: $event');
  }

  static _handleError(error) {
    print('Received error: ${error.message}');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await LinkPreview.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
