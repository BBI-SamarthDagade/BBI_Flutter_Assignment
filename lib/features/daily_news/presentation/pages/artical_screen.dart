import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_state.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_event.dart';
import 'package:news_app/features/daily_news/presentation/widgets/article_card.dart'; // Import the ArticleCard widget

class ArticleScreen extends StatelessWidget {
  final String placeholderImage = 'https://via.placeholder.com/150';
  final Function toggleTheme;
  int page = 1;
  bool isFetching = false;

  ArticleScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    // Pagination: Trigger fetch when nearing the bottom
    _scrollController.addListener(() {
      if (!isFetching &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        isFetching = true;
        page++;
        context.read<ArticleBloc>().add(FetchArticlesEvent(page: page));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleLoaded) {
            isFetching = false;
            return RefreshIndicator(
              onRefresh: () async {
                page = 1;
                context.read<ArticleBloc>().add(FetchArticlesEvent(page: page));
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: state.articles.length + 1, // Extra for loading indicator
                itemBuilder: (context, index) {
                  if (index == state.articles.length && index!=50) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(index!=50){
                    final article = state.articles[index];
                    return ArticleCard(article: article, placeholderImage: placeholderImage); 
                  }
                  else{
                    return Container();
                  }
                  // Use ArticleCard
                },
              ),
            );
          } else if (state is ArticleError) {
            isFetching = false;
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No articles available'));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_upward),
          color: Colors.blue,
          iconSize: 30.0,
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }
}