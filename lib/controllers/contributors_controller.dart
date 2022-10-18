import 'dart:io';
import 'dart:convert';
import 'package:gitmine/config/constants.dart';
import 'package:gitmine/config/utils/return_owner_repo.dart';
import 'package:gitmine/models/contributor.dart';
import 'package:gitmine/repositories/contributors_repository.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/shell.dart';

class ContributorsController {
  ContributorsController(this._contributorRepository);

  final ContributorRepository _contributorRepository;

  List<Contributor> listContributors = <Contributor>[];
  int page = 1;

  List<Contributor> contributorsResponse = <Contributor>[];

  Future<void> searchContributors(url) async {
    final String ownerRepo = returnOwnerRepo(url);
    final List<String> ownerRepoList = ownerRepo.split('/');

    contributorsResponse = await _contributorRepository.listContributors(
      ownerRepoList[0],
      ownerRepoList[1],
      page: page,
    );
    contributorsResponse.removeWhere((element) => element.contributions! < 10);
    listContributors.addAll(contributorsResponse);
    page++;
  }

  Future<void> printTopContributors(String url) async {
    final String ownerRepo = returnOwnerRepo(url);
    final List<String> ownerRepoList = ownerRepo.split('/');
    final String repo = ownerRepoList[1];

    await searchContributors(url);
    while (contributorsResponse.length == Constants.PER_PAGE) {
      await searchContributors(url);
    }

    print('');
    print('=============================================================');
    print('Top colaboradores');
    print('=============================================================');
    print('');
    listContributors.forEach((element) {
      print('${element.login} - ${element.contributions} commits');
    });
    print('');
    print('=============================================================');
    print('');
    if (listContributors.length >= 5) {
      print('Clonando o repositório..');
      var shell = Shell(throwOnError: false, commandVerbose: false);

      await shell.run('git clone $url');

      print('Projeto Clonado');
      shell = shell.cd(repo);
      print('');
      print('=============================================================');
      print('');
      print('Todos os ramos do repositório:');

      await shell.run('git branch -a');
      print('');
      print('=============================================================');
      print('');
      print('Quantidade de merges:');
      await shell.run('git rev-list --all --merges --count');
      print('');
      print('=============================================================');
      print('');
      print('Detalhes dos merges:');
      await shell.run(
        'git log --pretty="format:O autor de %h foi %an e o commiter foi %cn" --merges',
      );
    }
  }
}
