import 'package:gitmine/models/contributor.dart';
import '../config/constants.dart';
import '../config/http/http_client.dart';

abstract class ContributorRepository {
  Future<List<Contributor>> listContributors(
    String owner,
    String repo, {
    int page = 0,
    int perPage = 100,
  });
}

class ContributorRepositoryImpl implements ContributorRepository {
  final HttpClient _client;

  const ContributorRepositoryImpl(this._client);

  @override
  Future<List<Contributor>> listContributors(
    String owner,
    String repo, {
    int page = 1,
    int perPage = Constants.PER_PAGE,
  }) async {
    final Map<String, dynamic> query = {};
    query['page'] = page;
    query['per_page'] = perPage;
    final response = await _client.get(
      '$owner/$repo/contributors',
      queryParams: query,
    );
    final data = response.data as List;
    return data.map((e) => Contributor.fromJson(e)).toList();
  }
}
