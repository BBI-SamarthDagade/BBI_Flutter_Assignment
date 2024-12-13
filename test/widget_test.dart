// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';   //no need to add dependancy when project is created dependancy is added automatically

// import 'package:news_app/main.dart';

// void main() {

//   //testWidgets is function in flutter for widget testing
//      //description : purpose of test
//      //WidgetTester tester : interact with widget trigger event and check state during test

//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {

//     // Build our app in testing environment
//     await tester.pumpWidget(const MyApp());

//     // find.text('0'): finds 0 in widgets
//     expect(find.text('0'), findsOneWidget);   //expect(find.text('0'), equals(0));
//     expect(find.text('1'), findsNothing);
    

//     //find.byIcon(Icons.add)  : find add button inside UI
//     //tester.tap()  : click on that button
//     await tester.tap(find.byIcon(Icons.add)); 
//     await tester.pump();   //this function after clicking rebuild widget tree and reflect changes

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);

//     // find.text(String): Finds widgets by their text.
//     // find.byType(Type): Finds widgets by their type (e.g., Text, Button).
//     // find.byIcon(IconData): Finds widgets by their icon.



//   });
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:news_app/main.dart';

// void main(){
//   testWidgets('Test news Artical UI', (WidgetTester tester) async{
//     await tester.pumpWidget(const MyApp());

//     expect(find.byWidget(Icon(Icons.brightness_6)), findsOneWidget);

//     await tester.tap(find.byWidget(Icon(Icons.brightness_6))); 
//     await tester.pump();   
     
    

   

//   });
// }




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
import 'package:news_app/features/daily_news/presentation/widgets/article_card.dart';



void main() {
  late ArticleBloc articleBloc;

  setUp(() {
    articleBloc = ArticleBloc(FetchArticalUseCase(ArticleRepositoryImplementation(NewsApiServiceImpl())));
  });


  Widget createArticleScreen({required Function toggleTheme}) {
    return BlocProvider.value(
      value: articleBloc,
      child: MaterialApp(
        home: ArticleScreen(toggleTheme: toggleTheme),
      ),
    );
  }

    testWidgets('Displays error message when fetching articles fails', (WidgetTester tester) async {
    // Arrange
    articleBloc.emit(ArticleError('Failed to fetch articles'));

    // Act
    await tester.pumpWidget(createArticleScreen(toggleTheme: () {}));
    await tester.pump(); // Trigger a frame.

    // Assert
    expect(find.text('Failed to fetch articles'), findsOneWidget);
  }); 


  testWidgets('Displays loading indicator when articles are being fetched', (WidgetTester tester) async {
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
      Article(
        title: 'Article 1',
        description: 'Description 1',
        urlToImage: 'https://via.placeholder.com/150',
      ),
      Article(
        title: 'Article 2',
        description: 'Description 2',
        urlToImage: 'https://via.placeholder.com/150',
      ),
    ];

    // Emit the ArticleLoaded state with the list of articles
    articleBloc.emit(ArticleLoaded(articles));

    // Act: Build the widget
    await tester.pumpWidget(createArticleScreen(toggleTheme: () {})); // Build the widget

    // Assert: Check that the articles are displayed
    expect(find.text('Article 1'), findsOneWidget); // Verify Article 1 is displayed
    expect(find.text('Description 1'), findsOneWidget); // Verify Description 1 is displayed
    expect(find.text('Article 2'), findsOneWidget); // Verify Article 2 is displayed
    expect(find.text('Description 2'), findsOneWidget); // Verify Description 2 is displayed
  });


    testWidgets('ArticleCard displays "No Description" when description is null', (WidgetTester tester) async {
    // Arrange: Create a mock article with a null description
    final article = {
      'title': 'Sample Article',
      'description': null, // No description
      'urlToImage': 'https://via.placeholder.com/150',
    };

    // Act: Build the ArticleCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleCard(article: article),
        ),
      ),
    );

    // Assert: Check that the "No Description" text is displayed
    expect(find.text('No Description'), findsOneWidget);
  });
}       