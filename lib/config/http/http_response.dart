import 'utils/../response_status.dart';

abstract class HttpResponse {
  dynamic data;
  ResponseStatus? status;
}

class RequestException implements Exception, HttpResponse {
  RequestException({
    this.status,
    this.data,
  });

  RequestException.fromStatusCode({
    int? statusCode,
    this.data,
  }) {
    if (statusCode == null) {
      this.status = ResponseStatus.unknown;
      return;
    }

    this.status = ResponseStatusExtension.getErroKindByStatusCode(statusCode);
  }

  @override
  dynamic data;

  @override
  ResponseStatus? status;
}

class CustomHttpResponse implements HttpResponse {
  CustomHttpResponse.fromStatusCode({
    int? statusCode,
    this.data,
  }) {
    this.status = ResponseStatusExtension.getErroKindByStatusCode(statusCode);
  }
  @override
  dynamic data;

  @override
  ResponseStatus? status;
}
