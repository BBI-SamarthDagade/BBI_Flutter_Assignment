import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_app/core/failure.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/usecases/fetch_artical_use_case.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final FetchArticalUseCase fetchArticalUseCase;

  int _page = 1;

  ArticleBloc(this.fetchArticalUseCase) : super(ArticleInitial()) {
    on<FetchArticlesEvent>((event, emit) async {
      try {
        final Either<Failure, List<Article>> result =
            await fetchArticalUseCase(event.page, event.pageSize);

        result.fold((l) {
          emit(ArticleError(l.message));
        }, (r) {
          if (state is ArticleLoaded) {
            final currentState = state as ArticleLoaded;

            if (currentState != event.page) {
              emit(ArticleLoaded([...currentState.articles, ...r]));
            }
          } else {
            emit(ArticleLoaded(r));
          }

        });
      } catch (e) {
        emit(ArticleError('An unexpected error occured'));
      }
    });
  }
}
