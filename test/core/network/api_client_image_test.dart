import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/network/api_client.dart';

/// A server that keeps the last request and answers `{"ok": true}`.
class _Server implements HttpClientAdapter {
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    // The body has to be read for the request to finish.
    await requestStream?.drain<void>();
    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory folder;

  setUp(() => folder = Directory.systemTemp.createTempSync('api_image'));
  tearDown(() => folder.deleteSync(recursive: true));

  Future<MultipartFile> sent(String fileName) async {
    final file = File('${folder.path}${Platform.pathSeparator}$fileName')
      ..writeAsBytesSync([1, 2, 3]);
    final server = _Server();
    final api = ApiClient(baseUrl: 'http://test', adapter: server);

    await api.putImage('/profile/photo', field: 'photo', filePath: file.path);

    final request = server.last!;
    expect(request.method, 'PUT');
    expect(request.path, '/profile/photo');
    final part = (request.data as FormData).files.single;
    expect(part.key, 'photo');
    return part.value;
  }

  // The server refuses an image sent without its kind.
  test('an image is sent as the kind its name says', () async {
    final jpg = await sent('picked.jpg');
    expect(jpg.filename, 'picked.jpg');
    expect(jpg.contentType.toString(), 'image/jpeg');

    expect((await sent('picked.PNG')).contentType.toString(), 'image/png');
    expect((await sent('picked.webp')).contentType.toString(), 'image/webp');
  });

  test('a file with no known ending goes as a JPEG', () async {
    expect((await sent('picked')).contentType.toString(), 'image/jpeg');
  });
}
