import 'dart:convert';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/category.dart';

class DataInitialization {
  static Future<List<Article>> getFavorites(List<Article> favorites) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var favoritesString = prefs.getString('favorites');

    if (favoritesString != null) {
      favorites.addAll(json
          .decode(favoritesString)
          .map<Article>((m) => Article.simpleFromJson(m))
          .toList());
    }
    return favorites;
  }

  static Future<List<Category>> getCategories(List<Category> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var categoriesString = prefs.getString('categories');

    if (categoriesString == null || categoriesString.isEmpty) {
      await loadCategories();
      //getCategories(categories);
    }
    else if (categoriesString.length > 0)
    categories.addAll(json
        .decode(categoriesString)
        .map<Category>((m) => Category.fromJson(m))
        .toList());

    return categories;
  }

  static Future<void> loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var page = 1;
    bool hasMore = true;
    var tempCategories = new List<Category>();

    try {
      do {
        var url =
            "${con.WordpressUrl}/wp-json/wp/v2/categories?page=$page&per_page=40";

        var response =
            await http.get(url, headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          tempCategories.addAll(json
              .decode(response.body)
              .map<Category>((m) => Category.fromJson(m))
              .toList());

          if (tempCategories.length % 40 != 0) {
            hasMore = false;
            break;
          }
        }

        page++;
      } while (hasMore);

      await prefs.setString('categories', jsonEncode(tempCategories));
    } catch (e) {
      print(e);
    }
  }
}
