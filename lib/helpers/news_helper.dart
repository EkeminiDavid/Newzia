import 'package:http/http.dart' as http;
import 'package:newzia/constant.dart';
import 'dart:convert';
import 'package:newzia/models/articles.dart';

class News {
  Future<List<Article>> getWorldNewsCategory() async {
    List<Article> articles = [];
    var query = 'world news';
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&sortBy=popularity&sortBy=relevancy&apiKey=$kApiKey');
    final response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData['articles'].forEach((article) {
        Article newArticle = Article(
          title: article['title'] ?? '',
          source: article['author'] ?? '',
          urlToImage: article['urlToImage'] ?? '',
          publishAt: article['publishedAt'] ?? '',
          articleUrl: article["url"] ?? '',
        );

        articles.add(newArticle);
      });
    }
    return articles;
  }

  Future<Map<String, List<Article>>> getCategoryNews() async {
    Map<String, List<Article>> newsMap = {};

    List categories = [
      'General',
      'Health',
      'Entertainment',
      'Business',
      'Technology',
      'Sports',
      'politics'
    ];

    for (var category in categories) {
      List<Article> articles = [];
      String url =
          'https://newsapi.org/v2/top-headlines?country=ng&category=$category&sortBy=publishedAt&apiKey=$kApiKey';
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        jsonData['articles'].forEach((article) {
          Article newArticle = Article(
            title: article['title'] ?? '',
            source: article['author'] ?? '',
            urlToImage: article['urlToImage'] ?? '',
            publishAt: article['publishedAt'] ?? '',
            articleUrl: article["url"] ?? '',
          );

          articles.add(newArticle);
        });
        newsMap[category] = articles;
      }
    }

    return newsMap;
  }
}
