import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:http/http.dart' as http;

abstract class NewsApiService {

  Future<List<Article>> getNewsArticles(int page, int pageSize);

}

class NewsApiServiceImpl extends NewsApiService {
  
  @override
  Future<List<Article>> getNewsArticles(int page, int pageSize) async {

    final String? api_key = dotenv.env['API_KEY'];
     
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=technology&from=2024-16-12&language=en&sortBy=publishedAt&apiKey=$api_key&page=$page&pageSize=$pageSize'));
      print(response.statusCode);
    if (response.statusCode == 200) {
     Map<String, dynamic> data = jsonDecode(response.body);
     
      // Parse the JSON into a list of User objects
      List<dynamic> jsonResponse = data['articles'];

      return jsonResponse.map((data) => Article.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

