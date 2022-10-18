import 'dart:io' as io;
import 'http_response.dart';
import 'response_status.dart';
import 'package:dio/dio.dart';

abstract class HttpClient {
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  });

  Future<HttpResponse> post(
    String url, {
    dynamic body,
    CustomContentType? contentType,
    Map<String, dynamic>? queryParams,
    Options? options,
  });

  Future<HttpResponse> put(
    String url, {
    dynamic body,
    CustomContentType? contentType,
    Map<String, dynamic>? queryParams,
    Options? options,
  });

  Future<HttpResponse> delete(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  });

  Future<HttpResponse> download(
    String url,
    String pathSave,
  );
}

class HttpClientImpl implements HttpClient {
  HttpClientImpl(
    this._client,
    String baseUrl,
    List<Interceptor> interceptors,
  ) {
    _client = _client
      ..interceptors.addAll(interceptors)
      ..options.baseUrl = baseUrl;
  }

  Dio _client;

  void _setupHeaders({CustomContentType? contentType}) {
    final headers = _client.options.headers;
    headers[Headers.contentTypeHeader] = contentType.headerParameter;
    headers[Headers.acceptHeader] = contentType.headerParameter;
    _client.options.headers = headers;
  }

  RequestException _handleDioError(DioError error) {
    if (error.response == null && error.error is io.SocketException)
      return RequestException(status: ResponseStatus.withoutConnection);

    return RequestException.fromStatusCode(
      statusCode: error.response?.statusCode,
      data: error.response?.data,
    );
  }

  @override
  Future<CustomHttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    _setupHeaders();
    try {
      final dioResponse = await _client.get(
        url,
        queryParameters: queryParams,
        options: options,
      );

      return CustomHttpResponse.fromStatusCode(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode,
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<CustomHttpResponse> post(
    String url, {
    dynamic body,
    CustomContentType? contentType,
    Map<String, dynamic>? queryParams = const <String, dynamic>{},
    Options? options,
  }) async {
    _setupHeaders(contentType: contentType);

    try {
      final dioResponse = await _client.post(
        url,
        data: body,
        queryParameters: queryParams,
        options: options,
      );

      return CustomHttpResponse.fromStatusCode(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode,
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<CustomHttpResponse> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    CustomContentType? contentType = CustomContentType.applicationJson,
    Options? options,
  }) async {
    _setupHeaders(contentType: contentType);

    try {
      final dioResponse = await _client.put(
        url,
        data: body,
        queryParameters: queryParams,
        options: options,
      );

      return CustomHttpResponse.fromStatusCode(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode,
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<CustomHttpResponse> delete(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    _setupHeaders();

    try {
      final dioResponse = await _client.delete(
        url,
        queryParameters: queryParams,
        options: options,
      );

      return CustomHttpResponse.fromStatusCode(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode,
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<CustomHttpResponse> download(String url, String pathSave) async {
    _setupHeaders(contentType: CustomContentType.applicationPdf);

    try {
      final dioResponse = await _client.download(url, pathSave,
          options: Options(
            contentType: 'application/pdf',
            headers: {
              'content-type': 'application/pdf',
            },
          ));

      return CustomHttpResponse.fromStatusCode(
        data: pathSave,
        statusCode: dioResponse.statusCode,
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }
}

enum CustomContentType {
  applicationJson,
  multipartFormData,
  applicationPdf,
}

extension ContentTypeExtension on CustomContentType? {
  static const Map<CustomContentType, String> _map = {
    CustomContentType.applicationJson: 'application/json',
    CustomContentType.applicationPdf: 'application/pdf',
    CustomContentType.multipartFormData: 'multipart/form-data',
  };

  String? get headerParameter => _map[this] ?? 'application/json';
}
