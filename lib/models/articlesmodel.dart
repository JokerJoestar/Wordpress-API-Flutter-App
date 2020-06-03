import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'article.dart';
import 'package:timezone/data/latest.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;

class ArticlesModel {
  Stream<List<Article>> stream;
  bool hasMore;
  int page;
  String searchText;
  bool _isLoading;
  List<Article> _data;
  StreamController<List<Article>> _controller;
  String endpointUrl;
  int categoryId;

  ArticlesModel(String endpointUrl, int categoryId, String searchText) {
    this.endpointUrl = endpointUrl;
    this.searchText = searchText;
    this.categoryId = categoryId;

    _data = List<Article>();
    _controller = StreamController<List<Article>>.broadcast();
    _isLoading = false;

    stream = _controller.stream.map((List<Article> articlesData) {
      return articlesData;
    });

    initializeTimeZones();
    initializeDateFormatting('el_GR');
    hasMore = true;
    page = 1;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _data = List<Article>();
      page = 0;
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }

    page++;
    _isLoading = true;

    return loadArticles(endpointUrl, page, categoryId, searchText).then((articlesData) {
      _isLoading = false;
      _data.addAll(articlesData);
      _controller.add(_data);
    });
  }

  Future<List<Article>> loadArticles(String endpointUrl, int page, int categoryId, String searchText) async {
    var tempArticles = new List<Article>();
    var url = endpointUrl + "?page=$page&per_page=${con.PostsPerPage}&_embed";
  
    if(categoryId != null) {
      this.categoryId = categoryId;

      url += "&categories[]=$categoryId";
    }

    if(searchText != null) {
      this.searchText = searchText;

      url += "&search=$searchText";
    }

    var response = await http.get(url);

    hasMore = true;

    if (response.statusCode == 200) {
      tempArticles.addAll(json
          .decode(response.body)
          .map<Article>((m) => Article.fromJson(m))
          .toList());

      if (tempArticles.length % con.PostsPerPage != 0) {
        hasMore = false;
      }
    }

    return tempArticles;
  }

  removeDiacritics(String string) {
    Map<String, String> chars = {
      'ό': 'ο',
      'ά': 'α',
      'ί': 'ι',
      'έ': 'ε',
      'ύ': 'υ',
      'ώ': 'ω',
      'ή': 'η'
    };

    string = string.toLowerCase();

    chars.forEach((k, v) {
      string = string.replaceAll(k, v);
    });

    return string.toUpperCase();
  }
}
