import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchArticlesEvent extends ArticleEvent {
  int page;
  int pageSize;
  FetchArticlesEvent({this.page = 1, this.pageSize = 10});
}
