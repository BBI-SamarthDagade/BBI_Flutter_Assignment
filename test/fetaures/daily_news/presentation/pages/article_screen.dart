import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/daily_news/data/data_source/article_remote.dart';
import 'package:news_app/features/daily_news/data/repository/article_repo_impl.dart';
import 'package:news_app/features/daily_news/domain/entity/article.dart';
import 'package:news_app/features/daily_news/domain/usecases/fetch_artical_use_case.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_state.dart';
import 'package:news_app/features/daily_news/presentation/pages/artical_screen.dart';

void main() {
  
  late ArticleBloc articleBloc;

  setUp(() {
       articleBloc = ArticleBloc(FetchArticalUseCase(
        ArticleRepositoryImplementation(NewsApiServiceImpl())));
  });

  Widget createArticleScreen({required Function toggleTheme}) {
    return BlocProvider.value(
      value: articleBloc,
      child: MaterialApp(
        home: ArticleScreen(toggleTheme: toggleTheme),
      ),
    );
  }

  testWidgets('Displays error message when fetching articles fails',
      (WidgetTester tester) async {
    // Arrange
    articleBloc.emit(ArticleError('Failed to fetch articles'));

    // Act
    await tester.pumpWidget(createArticleScreen(toggleTheme: () {}));
    await tester.pump(); // Trigger a frame.

    // Assert
    expect(find.text('Failed to fetch articles'), findsOneWidget);
  });

  testWidgets('Displays loading indicator when articles are being fetched',
      (WidgetTester tester) async {
    // Arrange
    articleBloc.emit(ArticleLoading());

    // Act
    await tester.pumpWidget(createArticleScreen(toggleTheme: () {}));
    await tester.pump(); // Trigger a frame.

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays articles when loaded', (WidgetTester tester) async {
    // Arrange: Create sample articles
    final articles = [
      const Article(
        title: 'Article 1',
        description: 'Description 1',
        urlToImage: 'https://via.placeholder.com/150',
      ),
      const Article(
        title: 'Article 2',
        description: 'Description 2',
        urlToImage: 'https://via.placeholder.com/150',
      ),
    ];

    // Emit the ArticleLoaded state with the list of articles
    articleBloc.emit(ArticleLoaded(articles));

    // Act: Build the widget
    await tester.pumpWidget(
        createArticleScreen(toggleTheme: () {})); // Build the widget

    // Assert: Check that the articles are displayed
    expect(find.text('Article 1'),
        findsOneWidget); // Verify Article 1 is displayed
    expect(find.text('Description 1'),
        findsOneWidget); // Verify Description 1 is displayed
    expect(find.text('Article 2'),
        findsOneWidget); // Verify Article 2 is displayed
    expect(find.text('Description 2'),
        findsOneWidget); // Verify Description 2 is displayed
  });

  testWidgets('IconButton toggles wasTapped variable',
      (WidgetTester tester) async {

    bool wasTapped = false;

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () => wasTapped = !wasTapped,
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate tap on the IconButton
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pump(); // Rebuild the widget tree after the interaction

    // Verify the tap updated the variable
    expect(wasTapped, isTrue);
  });

  testWidgets('IconButton toggles wasTapped variable',
      (WidgetTester tester) async {

    bool wasTapped = false;

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () {
            wasTapped = !wasTapped;
          },
        ),
      ),
        ),
      ),
    );

    // Simulate tap on the IconButton
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump(); // Rebuild the widget tree after the interaction

    // Verify the tap updated the variable
    expect(wasTapped, isTrue);
  });
}