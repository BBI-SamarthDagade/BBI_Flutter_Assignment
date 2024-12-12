import 'package:fpdart/fpdart.dart';
import 'package:news_app/core/failure.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/repository/article_repository.dart';

class FetchArticalUseCase {
  final ArticleRepository newsApiServiceImpl;

  FetchArticalUseCase(this.newsApiServiceImpl);

  Future<Either<Failure, List<Article>>> call(int page, int pageSize) {
    return newsApiServiceImpl.getNewsArticles(page, pageSize);
  }
}
