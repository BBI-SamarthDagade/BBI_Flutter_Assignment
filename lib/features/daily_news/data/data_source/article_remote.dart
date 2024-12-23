import 'dart:convert';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/daily_news/data/data_source/article_remote.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';

abstract class NewsApiService {
  Future<List<Article>> getNewsArticles(int page, int pageSize);
}

class NewsApiServiceImpl extends NewsApiService {

  final http.Client client;

  NewsApiServiceImpl({required this.client});

  @override
  Future<List<Article>> getNewsArticles(int page, int pageSize) async {

    
    final String? api_key = dotenv.env['API_KEY'];

    if (api_key == null || api_key.isEmpty) {
  throw Exception('API Key is missing or invalid');
}

    final response = await client.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=latest&from=2024-19-12&language=en&sortBy=publishedAt&apiKey=$api_key&page=$page&pageSize=$pageSize'));

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

