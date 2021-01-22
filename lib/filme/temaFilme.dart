import 'package:http/http.dart';

Future<void> filmeAll() async {
  final List<String> listaNumeFilme = <String>[];
  final List<String> imaginiFilme = <String>[];
  final List<String> ratingFilme = <String>[];
  final List<String> aniFilme = <String>[];
  final List<int> ratingFilmeIntate = ratingFilme.map(int.parse).toList();

  final Response response =
      await get('https://yts.mx/api/v2/list_movies.json?page=1&limit=50');
  final String data = response.body;

  final List<String> parts = data.split('imdb_code":').skip(1).toList();
  for (final String part in parts) {
    final String title = part.split('title":"')[1].split('",')[0];
    listaNumeFilme.add(title);
    final String rating = part.split('rating":')[1].split(',')[0];
    ratingFilme.add(rating);
    final String an = part.split('year":')[1].split(',')[0];
    aniFilme.add(an);
    final String imaginiUrl = part
        .split('large_cover_image":"')[1]
        .split('",')[0]
        .replaceAll(r'\', r'');
    imaginiFilme.add(imaginiUrl);
    print(title + '\n' + rating + '\n' + an + '\n' + imaginiUrl + '\n');

    ratingFilmeIntate.sort();
    print(ratingFilmeIntate);
  }
}
