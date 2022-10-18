import 'package:dio/dio.dart';

import '../../http/http_client.dart';
import '../dependences_injector.dart';

void setupSharedInjections() {
  DependencesInjector.registerFactory<Dio>(() => Dio());

  DependencesInjector.registerFactory<LogInterceptor>(
    () => LogInterceptor(),
  );

  DependencesInjector.registerFactory<HttpClient>(() {
    return HttpClientImpl(
      DependencesInjector.get<Dio>(),
      'https://api.github.com/repos/',
      [
        DependencesInjector.get<LogInterceptor>(),
      ],
    );
  });
}
