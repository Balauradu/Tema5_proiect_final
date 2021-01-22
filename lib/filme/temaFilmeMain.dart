import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<int> colorCodes = <int>[400, 470, 420, 450, 500, 525];
  final List<String> listaNumeFilme = <String>[];
  final List<String> imaginiFilme = <String>[];
  List<String> ratingFilme = <String>[];
  final List<String> aniFilme = <String>[];
  final List<String> genul = <String>[];
  List<double> ratingFilmeIntate = <double>[];

  @override
  void initState() {
    super.initState();
    filmeAll();
  }

  Future<void> filmeAll() async {
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
      final String genre = part.split('[')[1].split(']')[0];
      genul.add(genre);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(0, 300),
            bottomRight: Radius.elliptical(0, 300),
            topLeft: Radius.elliptical(2, 100),
            topRight: Radius.elliptical(2, 100),
          ),
        ),
        elevation: 6,
        centerTitle: true,
        backgroundColor: const Color(0xff0000ca),
        title: const Text(
          'Movie List',
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontFamily: 'Cormorant Infant',
            //ignore: always_specify_types
            shadows: [
              Shadow(
                color: Colors.black87,
                blurRadius: 0.8,
                offset: Offset(1.3, 1),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        overlayColor: Colors.black87,
        elevation: 10.0,
        backgroundColor: const Color(0xff0000ca),
        foregroundColor: Colors.white,
        animatedIconTheme: const IconThemeData.fallback(),
        // ignore: always_specify_types
        children: [
          SpeedDialChild(
            child: const Icon(Icons.arrow_circle_down),
            backgroundColor: const Color(0xff0000ca),
            label: 'Ascending order by rating:',
          ),
          SpeedDialChild(
              child: const Icon(Icons.arrow_circle_up),
              backgroundColor: const Color(0xff0000ca),
              label: 'Descending order by rating:'),
        ],
      ),
      body: ListView.builder(
        itemCount: listaNumeFilme.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: const BoxDecoration(
                // ignore: always_specify_types
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5.5,
                    blurRadius: 18,
                    offset: Offset(0, 3),
                  ),
                ], // changes position of shadow
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Color(0xff501bff),
              ),
              child: Column(
                // ignore: always_specify_types
                children: [
                  Image.network(
                    imaginiFilme.elementAt(index),
                    width: 300,
                    height: 550,
                    alignment: Alignment.center,
                  ),
                  Text(
                    'Name: ' +
                        listaNumeFilme.elementAt(index) +
                        '\n' +
                        'Mark: ' +
                        ratingFilme.elementAt(index) +
                        '\n' +
                        'App year: ' +
                        aniFilme.elementAt(index) +
                        '\n',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cormorant Infant',
                      // ignore: always_specify_types
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 2.0,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
