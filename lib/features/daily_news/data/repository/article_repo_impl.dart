import 'package:fpdart/src/either.dart';
import 'package:news_app/core/failure.dart';
import 'package:news_app/features/daily_news/data/data_source/article_remote.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImplementation implements ArticleRepository {
  final NewsApiService newsApiService;

  ArticleRepositoryImplementation(this.newsApiService);

  @override
  Future<Either<Failure, List<Article>>> getNewsArticles(int page, int pageSize) async {

    try {
       
      final httpResponse = await newsApiService.getNewsArticles(page, pageSize);
      
      

      return Right(httpResponse);
    } catch (e) {
      return Left(Failure(message: 'Failed to fetch News'));
    }
  }
}
