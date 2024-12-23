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
  late ArticleBloc articleBloc; //instance of articleBoc
  late MockFetchArticleUseCase mockFetchArticleUseCase;

  setUp(() {
    mockFetchArticleUseCase = MockFetchArticleUseCase();
    articleBloc = ArticleBloc(mockFetchArticleUseCase);

    registerFallbackValue(FetchArticlesEvent(page: 1, pageSize: 10));
  });

  //this function called after each test case and used to cleanup resources initialized during setup method,
  //This is important to prevent any side effects from one test affecting another.
  tearDown(() {
    articleBloc.close();
  });

  // group(description, body){}  : is used to organize realated testcases into single group.
  group('ArticleBloc', () {
    test('initial state is ArticleInitial', () {
      expect(articleBloc.state, ArticleInitial());
    });

    //blocTest<ArticleBloc, ArticleState>() this function is part of bloc_test package used to create test for BLOC
    //blocTest<B, S>(description, build: build); B : type of bloc is being tested(ArticleBloc) S : type of state emmited by BLOC(ArticleState)
    blocTest<ArticleBloc, ArticleState>(
      'emits [ArticleLoading, ArticleLoaded] when FetchArticlesEvent is added and use case returns articles',
      build: () {   //create instance of articleBloc and setup for testing and passed to act
      
        when(() => mockFetchArticleUseCase.call(1, 10)).thenAnswer(
          (_) async => Right([Article(title: 'Test Article')]),
        );
        return articleBloc;
      },
      
      //here we call FetchArticleEvent
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 1, pageSize: 10)),
      
      expect: () => [
        ArticleLoaded([Article(title: 'Test Article')]),
      ],
      verify: (_) {
        verify(() => mockFetchArticleUseCase.call(1, 10)).called(1);
      },
    );

    blocTest<ArticleBloc, ArticleState>(
      'emits [ArticleError] when FetchArticlesEvent is added and use case returns a failure',
      build: () {
        when(() => mockFetchArticleUseCase.call(1, 10)).thenAnswer(
          (_) async => Left(Failure(message: 'Error fetching articles')),
        );

        return articleBloc;
      },
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 1, pageSize: 10)),

      expect: () => [
        ArticleError('Error fetching articles'),
      ],

      verify: (_) {
        verify(() => mockFetchArticleUseCase(1, 10)).called(1);
      },
    );

    blocTest<ArticleBloc, ArticleState>(
      'emits [ArticleError] when an unexpected error occurs',
      build: () {
        when(() => mockFetchArticleUseCase.call(1, 10)).thenThrow(Exception());
        return articleBloc;
      },
      
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 1, pageSize: 10)),

      expect: () => [
        ArticleError('An unexpected error occured'),
      ],
    );

    blocTest<ArticleBloc, ArticleState>(
      'appends articles when new page is fetched',
      build: () {
        when(() => mockFetchArticleUseCase(1, 10)).thenAnswer(
          (_) async => Right([Article(title: 'Article 1')]),
        );
        when(() => mockFetchArticleUseCase(2, 10)).thenAnswer(
          (_) async => Right([Article(title: 'Article 2')]),
        );
        return articleBloc;
      },
      act: (bloc) async {
        bloc.add(FetchArticlesEvent(page: 1, pageSize: 10));
        await Future.delayed(Duration.zero);
        bloc.add(FetchArticlesEvent(page: 2, pageSize: 10));
      },
      expect: () => [
        ArticleLoaded([Article(title: 'Article 1')]),
        ArticleLoaded(
            [Article(title: 'Article 1'), Article(title: 'Article 2')]),
      ],
      verify: (_) {
        verify(() => mockFetchArticleUseCase(1, 10)).called(1);
        verify(() => mockFetchArticleUseCase(2, 10)).called(1);
      },
    );

    blocTest<ArticleBloc, ArticleState>(
      'stops fetching when page exceeds 5',
      build: () => articleBloc,
      act: (bloc) => bloc.add(FetchArticlesEvent(page: 6, pageSize: 10)),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockFetchArticleUseCase(any(), any()));
      },
    );
  });
}
