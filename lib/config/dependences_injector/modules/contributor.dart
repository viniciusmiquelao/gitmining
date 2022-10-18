import 'package:gitmine/controllers/contributors_controller.dart';

import '../../../repositories/contributors_repository.dart';
import '../../http/http_client.dart';
import '../dependences_injector.dart';

void setupContributorInjections() {
  DependencesInjector.registerFactory<ContributorRepository>(
    () => ContributorRepositoryImpl(
      DependencesInjector.get<HttpClient>(),
    ),
  );

  DependencesInjector.registerFactory<ContributorsController>(
    () => ContributorsController(
      DependencesInjector.get<ContributorRepository>(),
    ),
  );
}
