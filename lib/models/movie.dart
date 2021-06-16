// To parse this JSON data, do
//
//     final movie = movieFromJson(jsonString);

import 'dart:convert';

class Movie {
  Movie({
    this.posterPath,
    this.video,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.voteCount,
    this.adult,
    this.backdropPath,
    this.title,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.popularity,
    this.mediaType,
  });

  String posterPath;
  bool video;
  double voteAverage;
  String overview;
  DateTime releaseDate;
  int voteCount;
  bool adult;
  String backdropPath;
  String title;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  double popularity;
  String mediaType;

  String get posterPathFull {
    return 'https://image.tmdb.org/t/p/w200/' + this.posterPath;
  }

  Movie copyWith({
    String posterPath,
    bool video,
    double voteAverage,
    String overview,
    DateTime releaseDate,
    int voteCount,
    bool adult,
    String backdropPath,
    String title,
    List<int> genreIds,
    int id,
    String originalLanguage,
    String originalTitle,
    double popularity,
    String mediaType,
  }) =>
      Movie(
        posterPath: posterPath ?? this.posterPath,
        video: video ?? this.video,
        voteAverage: voteAverage ?? this.voteAverage,
        overview: overview ?? this.overview,
        releaseDate: releaseDate ?? this.releaseDate,
        voteCount: voteCount ?? this.voteCount,
        adult: adult ?? this.adult,
        backdropPath: backdropPath ?? this.backdropPath,
        title: title ?? this.title,
        genreIds: genreIds ?? this.genreIds,
        id: id ?? this.id,
        originalLanguage: originalLanguage ?? this.originalLanguage,
        originalTitle: originalTitle ?? this.originalTitle,
        popularity: popularity ?? this.popularity,
        mediaType: mediaType ?? this.mediaType,
      );

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        video: json["video"] == null ? null : json["video"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toDouble(),
        overview: json["overview"] == null ? null : json["overview"],
        releaseDate: json["release_date"] == null ? null : DateTime.parse(json["release_date"]),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        adult: json["adult"] == null ? null : json["adult"],
        backdropPath: json["backdrop_path"] == null ? null : json["backdrop_path"],
        title: json["title"] == null ? null : json["title"],
        genreIds: json["genre_ids"] == null ? null : List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        originalLanguage: json["original_language"] == null ? null : json["original_language"],
        originalTitle: json["original_title"] == null ? null : json["original_title"],
        popularity: json["popularity"] == null ? null : json["popularity"].toDouble(),
        mediaType: json["media_type"] == null ? null : json["media_type"],
      );

  Map<String, dynamic> toJson() => {
        "poster_path": posterPath == null ? null : posterPath,
        "video": video == null ? null : video,
        "vote_average": voteAverage == null ? null : voteAverage,
        "overview": overview == null ? null : overview,
        "release_date": releaseDate == null
            ? null
            : "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "vote_count": voteCount == null ? null : voteCount,
        "adult": adult == null ? null : adult,
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "title": title == null ? null : title,
        "genre_ids": genreIds == null ? null : List<dynamic>.from(genreIds.map((x) => x)),
        "id": id == null ? null : id,
        "original_language": originalLanguage == null ? null : originalLanguage,
        "original_title": originalTitle == null ? null : originalTitle,
        "popularity": popularity == null ? null : popularity,
        "media_type": mediaType == null ? null : mediaType,
      };
}
