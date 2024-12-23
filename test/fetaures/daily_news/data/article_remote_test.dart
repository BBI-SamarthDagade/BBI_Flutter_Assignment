import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/daily_news/data/data_source/article_remote.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';

// Mock HTTP client
class MockClient extends Mock implements http.Client {}

// Register a fake Uri to resolve the fallback issue
class FakeUri extends Fake implements Uri {}

void main() {
  late NewsApiServiceImpl newsApiService;
  late MockClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() async {
    mockHttpClient = MockClient();

    // Initialize dotenv with mock data
    dotenv.testLoad(fileInput: '''
      API_KEY=test_api_key
    ''');

    newsApiService = NewsApiServiceImpl(client: mockHttpClient);
  });

  group('NewsApiServiceImpl', () {
    test('fetches news articles successfully when response is 200', () async {
      // Arrange
      final mockResponse = {
        'status': 'ok',
        'totalResults': 2,
        'articles': [
          {
            'title': 'Breaking News',
            'description': 'This is a breaking news article.',
            'urlToImage': 'https://example.com/news1.jpg',
          },
          {
            'title': 'Latest Update',
            'description': 'Here is the latest update.',
            'urlToImage': 'https://example.com/news2.jpg',
          }
        ]
      };

      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      // Act
      final result = await newsApiService.getNewsArticles(1, 10);

      // Assert
      expect(result, isA<List<Article>>());
      expect(result.length, 2);
      expect(result[0].title, 'Breaking News');
      expect(result[1].title, 'Latest Update');
    });

    test('throws exception when API key is missing', () async {
      // Arrange
      dotenv.testLoad(fileInput: '');

      // Act & Assert
      expect(
        () => newsApiService.getNewsArticles(1, 10),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('API Key is missing or invalid'))),
      );
    });

    test('throws exception when API key is empty', () async {
      // Arrange
      dotenv.testLoad(fileInput: '''
        API_KEY=
      ''');

      // Act & Assert
      expect(
        () => newsApiService.getNewsArticles(1, 10),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('API Key is missing or invalid'))),
      );
    });
  });
}
