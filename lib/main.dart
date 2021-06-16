import 'dart:convert';

import 'package:DevHubApp/models/movie.dart';
import 'package:DevHubApp/widgets/content_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;

void main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latest Movies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }),
      ),
      home: LatestMoviesPage(),
    );
  }
}

class LatestMoviesPage extends StatefulWidget {
  LatestMoviesPage({Key key}) : super(key: key);
  @override
  _LatestMoviesPageState createState() => _LatestMoviesPageState();
}

class _LatestMoviesPageState extends State<LatestMoviesPage> {
  int page = 0;
  bool hasReachedMax = false;
  bool isLoading = false;
  List<Movie> movies = [];
  ScrollController _scrollController;
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _scrollController = new ScrollController();
    _scrollController.addListener(_onScroll);
    this.loadMovies();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      this.loadMovies();
    }
  }

  void loadMovies() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var movieApiKey = 'SET_MOVIE_API_KEY';
      var p = this.page > 0 ? this.page : 1;
      var url = 'https://api.themoviedb.org/3/trending/movie/week?api_key=$movieApiKey&page=$p';
      http.get(url).then((response) {
        var data = json.decode(response.body);
        List<Movie> movieItems = (data['results'] as List).map((x) => Movie.fromJson(x)).toList();
        setState(() {
          this.movies.addAll(movieItems);
          page++;
          isLoading = false;
        });
      }).catchError((error) {
        var e = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
              child: Text(
                'Latest Movies',
                style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Step 1
          // SliverPadding(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //   sliver: SliverGrid(
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2, childAspectRatio: (3 / 4), crossAxisSpacing: 8, mainAxisSpacing: 8),
          //       delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          //         return Card(
          //           margin: EdgeInsets.all(0),
          //           child: Container(
          //             color: Colors.blue[100 * (index % 9 + 1)],
          //             alignment: Alignment.center,
          //             child: Text(
          //               "Item $index",
          //               style: TextStyle(fontSize: 30),
          //             ),
          //           ),
          //         );
          //       }, childCount: 10)),
          // ),

          // Step 2
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: (3 / 4), crossAxisSpacing: 16, mainAxisSpacing: 16),
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  Movie movie = movies[index];

                  return Stack(
                    overflow: Overflow.visible,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.all(0),
                        elevation: 0,
                        child: ContentImage(
                          url: movie.posterPathFull,
                        ),
                      ),
                      Positioned(
                          top: -6,
                          right: -6,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          value: movie.voteAverage / 10,
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                        ),
                                      ),
                                      Center(
                                          child: RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: DefaultTextStyle.of(context).style,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: (movie.voteAverage * 10).toStringAsFixed(0),
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            TextSpan(text: '%', style: TextStyle(fontSize: 10)),
                                          ],
                                        ),
                                      )
                                          //   Text(
                                          // '75',
                                          // style: TextStyle(fontSize: 10),
                                          )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  );
                }, childCount: this.movies.length)),
          ),
          hasReachedMax
              ? SizedBox.shrink()
              : SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                      child: Center(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(),
                        ),
                      )),
                )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// List Stage 1
