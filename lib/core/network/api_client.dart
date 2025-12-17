import 'dart:io';
import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

enum ApiErrorKind { network, http, unauthorized, parse, unknown }

class ApiException implements Exception {
  final ApiErrorKind kind;
  final int? statusCode;
  final String message;
  final Uri? url;

  ApiException({
    required this.kind,
    required this.message,
    this.statusCode,
    this.url,
  });

  @override
  String toString() => 'ApiException($kind, $statusCode, $message, $url)';
}

class ApiClient {
  final String _baseUrl;

  ApiClient() : _baseUrl = dotenv.env['API_URL'].toString();

  Uri _defineUriUrl({required String path}) {
    return Uri.https(_baseUrl, '/$path');
  }

  Stream<http.Response> get(String path) {
    final url = _defineUriUrl(path: path);
    final client = http.Client();

    return Stream.fromFuture(client.get(url))
        .map((response) {
          _ensureSuccess(response, url);
          return response;
        })
        .handleError((error) {
          throw _mapError(error, url);
        });
  }

  void _ensureSuccess(http.Response r, Uri url) {
    if (r.statusCode >= 200 && r.statusCode < 300) return;

    final kind = (r.statusCode == 401 || r.statusCode == 403)
        ? ApiErrorKind.unauthorized
        : ApiErrorKind.http;

    throw ApiException(
      kind: kind,
      statusCode: r.statusCode,
      message: 'HTTP error ${r.statusCode}',
      url: url,
    );
  }

  ApiException _mapError(Object error, Uri url) {
    if (error is ApiException) return error;

    if (error is SocketException || error is TimeoutException) {
      return ApiException(
        kind: ApiErrorKind.network,
        message: 'Ha ocurrido un error de red, por favor intente nuevamente.',
        url: url,
      );
    }

    if (error is ClientException) {
      return ApiException(
        kind: ApiErrorKind.network,
        message: 'Ha ocurrido un error de cliente HTTP.',
        url: url,
      );
    }

    return ApiException(
      kind: ApiErrorKind.unknown,
      message: error.toString(),
      url: url,
    );
  }
}
