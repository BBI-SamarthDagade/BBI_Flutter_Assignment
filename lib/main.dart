
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article_event.dart';
import 'package:news_app/features/daily_news/presentation/pages/artical_screen.dart';
import 'package:news_app/service_locator.dart';
import 'package:news_app/config/theme/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  setupLocator(); // Initialize service locator
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  //this function get current theme from shared preferance
  //assign this value to -isDarkMode
  Future<void> _loadThemePreference() async {
    bool isDarkMode = await ThemeManager.getThemePreference();
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }
  
  //toggels current theme
  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    //set toggeled theme in shared preferances
    await ThemeManager.setThemePreference(_isDarkMode); // Save preference
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),

      home: BlocProvider<ArticleBloc>(
        create: (context) => serviceLocator<ArticleBloc>()
          ..add(
            FetchArticlesEvent(),
          ),
          child: ArticleScreen(toggleTheme: _toggleTheme,
      ),
    )
    );
  }
}