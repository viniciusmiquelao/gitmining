String returnOwnerRepo(String url) {
  final ownerRepo =
      url.replaceAll('https://github.com/', '').replaceAll('github.com/', '');
  return ownerRepo;
}
