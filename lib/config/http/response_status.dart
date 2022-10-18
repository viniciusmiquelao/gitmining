enum ResponseStatus {
  success,
  created,
  conflict,
  noContent,
  badRequest,
  unauthorized,
  authenticatedUnauthorized,
  notFound,
  notAcceptable,
  internalServerError,
  withoutConnection,
  unprocessableEntity,
  preconditionFailed,
  unknown,
}

extension ResponseStatusExtension on ResponseStatus {
  static Map<int, ResponseStatus> get _status => {
        200: ResponseStatus.success,
        201: ResponseStatus.created,
        204: ResponseStatus.noContent,
        400: ResponseStatus.badRequest,
        401: ResponseStatus.unauthorized,
        403: ResponseStatus.authenticatedUnauthorized,
        404: ResponseStatus.notFound,
        406: ResponseStatus.notAcceptable,
        409: ResponseStatus.conflict,
        412: ResponseStatus.preconditionFailed,
        422: ResponseStatus.unprocessableEntity,
        500: ResponseStatus.internalServerError,
      };

  static ResponseStatus getErroKindByStatusCode(int? statusCode) {
    return _status[statusCode!] ?? ResponseStatus.unknown;
  }
}
