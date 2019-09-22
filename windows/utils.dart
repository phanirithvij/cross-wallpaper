import 'dart:io';

Future downloadFile(String url, String filename) async {
  await HttpClient()
      .getUrl(Uri.parse(url))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) =>
          response.pipe(File(filename).openWrite()));
}
