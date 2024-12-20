import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/core/failure.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app/features/daily_news/domain/usecases/fetch_artical_use_case.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  int page = 1;
  int pageSize = 10;

  late FetchArticalUseCase fetchArticalUseCase;
  late ArticleRepository articleRepository;

  //setup method run before every single test
  setUp(() {
    articleRepository = MockArticleRepository();
    fetchArticalUseCase = FetchArticalUseCase(articleRepository);
  });

  final mockArticleList = [
    Article(
      title: 'Article 1',
      description: 'Description 1',
      urlToImage: 'http://image1.com',
    ),
    Article(
      title: 'Article 2',
      description: 'Description 2',
      urlToImage: 'http://image2.com',
    )
  ];

  test("should get news from the repository", () async {
    //arrenge
    when(() => articleRepository.getNewsArticles(page, pageSize))
        .thenAnswer((_) async => Right(mockArticleList));

    //act
    final result = await fetchArticalUseCase.call(page, pageSize);

    //assert
    expect(result.isRight(), true);

    result.fold((l) {
      fail("Failed to Fetch News");
    }, (r) {
      expect(r, mockArticleList);
    });

    //verify that the getNews Articles methods should call one time
    verify(() => articleRepository.getNewsArticles(page, pageSize)).called(1);

    //ensure that no other method is called using instance articleRepository
    verifyNoMoreInteractions(articleRepository);

    //ensure that get news article method never called using articleRepository instance
    verifyNever(() => articleRepository.getNewsArticles(page, pageSize));
  });

  test("Should get Error From Repository", () async {
    //arrenge
    when(() => articleRepository.getNewsArticles(page, pageSize)).thenAnswer(
        (_) async => Left(Failure(message: "Failed to fetch news")));

    //act
    final result = await fetchArticalUseCase.call(page, pageSize);

    //assert
    expect(result.isLeft(), true);

    result.fold((l) {
      expect(l.message, "Failed to fetch news");
    }, (r) {
      fail("News Fetced successfully");
    });

    //verify that the getNews Articles methods should call one time
    verify(() => articleRepository.getNewsArticles(page, pageSize)).called(1);

    //ensure that no other method is called using instance articleRepository
    verifyNoMoreInteractions(articleRepository);

    //ensure that get news article method never called using articleRepository instance
    verifyNever(() => articleRepository.getNewsArticles(page, pageSize));
  });
}
