import 'package:get_it/get_it.dart';

import 'modules/contributor.dart';
import 'modules/shared.dart';

typedef FactoryFunc<T> = T Function();

class DependencesInjector {
  static final GetIt _locator = GetIt.instance;

  static T get<T extends Object>({String? instanceName}) {
    return _locator.get(instanceName: instanceName);
  }

  static void registerFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  }) {
    _locator.registerFactory(factoryFunc, instanceName: instanceName);
  }

  static void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _locator.registerLazySingleton(
      factoryFunc,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  static void setup() {
    setupSharedInjections();
    setupContributorInjections();
  }
}
