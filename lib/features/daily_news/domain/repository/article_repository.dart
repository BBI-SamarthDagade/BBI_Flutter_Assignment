import 'package:fpdart/fpdart.dart';
import 'package:news_app/core/failure.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';

abstract class ArticleRepository {
  
    Future<Either<Failure, List<Article> >> getNewsArticles(int page, int pageSize);
}

