import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/core/failure.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/usecases/fetch_artical_use_case.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_event.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_state.dart';

// Mock class for FetchArticalUseCase
class MockFetchArticleUseCase extends Mock implements FetchArticalUseCase {}

void main() {
  late ArticleBloc articleBloc;
  late MockFetchArticleUseCase mockFetchArticleUseCase;

  // Set up before each test
  setUp(() {
    mockFetchArticleUseCase = MockFetchArticleUseCase();
    articleBloc = ArticleBloc(mockFetchArticleUseCase);
  });

  // Clean up after each test
  tearDown(() {
    articleBloc.close();
  });

  group('ArticleBloc', () {
    test('initial state is ArticleInitial', () {
      expect(articleBloc.state, ArticleInitial());
    });

    blocTest<ArticleBloc, ArticleState>(
      'emits [ArticleLoaded] when FetchArticlesEvent is added and use case returns articles',
      build: () {
        when(() => mockFetchArticleUseCase(any(), any())).thenAnswer(
          (_) async => Right([Article(title: 'Test Article')]),
        );
        return articleBloc;
      },
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 1, pageSize: 10)),
      expect: () => [
        ArticleLoaded([Article(title: 'Test Article')]),
      ],
    );


    blocTest<ArticleBloc, ArticleState>(
      'emits [ArticleError] when FetchArticlesEvent is added and use case returns a failure',
      build: () {
        when(() => mockFetchArticleUseCase(any(), any())).thenAnswer(
          (_) async => Left(Failure(message: 'Error fetching articles')),
        );
        return articleBloc;
      },
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 1, pageSize: 10)),
      expect: () => [
        ArticleError('Error fetching articles'),
      ],
    );

    blocTest<ArticleBloc, ArticleState>(
      'emits [ArticleError] when an unexpected error occurs',
      build: () {
        when(() => mockFetchArticleUseCase(any(), any())).thenThrow(Exception());
        return articleBloc;
      },
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 1, pageSize: 10)),
      expect: () => [
        ArticleError('An unexpected error occured'),
      ],
    );
  });
}
