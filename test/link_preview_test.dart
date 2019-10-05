import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link_preview/link_preview.dart';

void main() {
  const MethodChannel channel = MethodChannel('link_preview');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LinkPreview.platformVersion, '42');
  });
}
