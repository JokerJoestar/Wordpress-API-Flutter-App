import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/standalone.dart';

class Article {
  Article(
    {this.id,
    this.postImage,
    this.description,
    this.link,
    this.content,
    this.publishedDate,
    this.categories,
    this.title}
  );

  final int id;
  final String postImage;
  final String description;
  final String link;
  final String publishedDate;
  final String content;
  final List<int> categories;
  final String title;

  @override
  toString() {
    return this.title;
  }
  
  factory Article.simpleFromJson(Map<String, dynamic> json) {
    return Article(id: json['id'],
        publishedDate: json['publishedDate'],
        link: json['link'],
        content: json['content'],
        title: json['title'],
        description: json['description'],
        postImage: json['postImage'],
        categories: json['categories'].cast<int>());
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    initializeTimeZones();
    initializeDateFormatting('el_GR');
    var unescape = new HtmlUnescape();

    DateFormat f = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime t = f.parse((json['date_gmt'] as String).replaceFirst("T", " "), true);

    String dateTimeGR = DateFormat("d MMMM yyyy, HH:mm", 'el_GR')
              .format(new TZDateTime.from(t, getLocation('Europe/Athens')))
              .toString();

    String postImage = '';

    var document = parse(json['excerpt']['rendered']);
    String description = parse(document.body.text).documentElement.text;
    
    try {
        postImage = json['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url'];
    } on NoSuchMethodError catch (_) {
    }

    return Article(id: json['id'],
        publishedDate: dateTimeGR,
        link: json['link'],
        content: json['content']['rendered'],
        title: unescape.convert(json['title']['rendered']),
        description: description,
        postImage: postImage,
        categories: json['categories'].cast<int>());
  }

  Map toJson() => {
    'id': id,
    'title': title,
    'postImage': postImage,
    'description': description,
    'link': link,
    'publishedDate': publishedDate,
    'content': content,
    'categories': categories
  };
}
