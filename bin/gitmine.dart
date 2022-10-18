import 'dart:io';

import 'package:gitmine/config/dependences_injector/dependences_injector.dart';
import 'package:gitmine/controllers/contributors_controller.dart';

void main(List<String> arguments) async {
  DependencesInjector.setup();
  final ContributorsController contributorsController =
      DependencesInjector.get<ContributorsController>();
  print(
    'Entre com a url de um repositorio publico do github. Ex: https://github.com/owner/repository',
  );
  final String url = stdin.readLineSync()!;
  await contributorsController.printTopContributors(url);
}
