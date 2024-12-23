// // // service_locator.dart
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart';
// import 'package:news_app/features/daily_news/data/data_source/article_remote.dart';
// import 'package:news_app/features/daily_news/data/repository/article_repo_impl.dart';
// import 'package:news_app/features/daily_news/domain/repository/article_repository.dart';
// import 'package:news_app/features/daily_news/domain/usecases/fetch_artical_use_case.dart';
// import 'package:news_app/features/daily_news/presentation/bloc/article_bloc.dart';

// //GetIt.instance creates a singleton instance of the GetIt service locator, ensuring all components in the app access the same instance.
// final serviceLocator = GetIt.instance;

// //setup all dependancies require for app
// void setupLocator() {
//   //The object is not created immediately during app startup. Instead, it is instantiated only when it is accessed for the first time.
//   // Register services
//   serviceLocator
//       .registerLazySingleton<NewsApiService>(() => NewsApiServiceImpl());

//   // Register repositories
//   serviceLocator.registerLazySingleton<ArticleRepository>(
//       () => ArticleRepositoryImplementation(serviceLocator<NewsApiService>()));

//   // Register use cases
//   serviceLocator.registerLazySingleton<FetchArticalUseCase>(
//       () => FetchArticalUseCase(serviceLocator<ArticleRepository>()));

// // Register blocs
// //   This registers a factory for the ArticleBloc class in the GetIt service locator.
// //   It ensures that every time the ArticleBloc is requested from the service locator,
// //  a new instance is created, with its required dependency (FetchArticalUseCase) automatically injected.

//   serviceLocator.registerFactory(
//       () => ArticleBloc(serviceLocator<FetchArticalUseCase>()));
// }


// service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:news_app/features/daily_news/data/data_source/article_remote.dart';
import 'package:news_app/features/daily_news/data/repository/article_repo_impl.dart';
import 'package:news_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app/features/daily_news/domain/usecases/fetch_artical_use_case.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_bloc.dart';

//GetIt.instance creates a singleton instance of the GetIt service locator, ensuring all components in the app access the same instance.
final serviceLocator = GetIt.instance;

//setup all dependancies require for app
void setupLocator() {
  //The object is not created immediately during app startup. Instead, it is instantiated only when it is accessed for the first time.
  // Register services
  serviceLocator
      .registerLazySingleton<NewsApiService>(() => NewsApiServiceImpl(client: Client()));

  // Register repositories
  serviceLocator.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImplementation(serviceLocator<NewsApiService>()));

  // Register use cases
  serviceLocator.registerLazySingleton<FetchArticalUseCase>(
      () => FetchArticalUseCase(serviceLocator<ArticleRepository>()));

// Register blocs
//   This registers a factory for the ArticleBloc class in the GetIt service locator.
//   It ensures that every time the ArticleBloc is requested from the service locator,
//  a new instance is created, with its required dependency (FetchArticalUseCase) automatically injected.

  serviceLocator.registerFactory(
      () => ArticleBloc(serviceLocator<FetchArticalUseCase>()));
}
