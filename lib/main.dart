import 'package:UPEI_NEWSAPP/news/model/auth/auth_service.dart';
import 'package:UPEI_NEWSAPP/news/model/news_item.dart';
import 'package:UPEI_NEWSAPP/news/model/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'news/model/fetcher/fetcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    // Wrap the app with ChangeNotifierProvider for InternetConnectivityProvider
    ChangeNotifierProvider(
      create: (context) => InternetConnectivityProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPEI News Reader',
      initialRoute: '/',
      routes: {
        '/': (context) => const NewsArticlesHome(),
        '/offline': (context) => const OfflineArticlesScreen(),
      },
    );
  }
}

class NewsArticlesHome extends StatefulWidget {
  const NewsArticlesHome({Key? key}) : super(key: key);

  @override
  _NewsArticleState createState() => _NewsArticleState();
}

class _NewsArticleState extends State<NewsArticlesHome> {
  late UPEINewsSource newsSource;
  List<NewsItem> articles = [];
  List<NewsItem> readArticles = [];
  bool isLoading = true;
  bool isCheckingConnectivity = true; // Add isCheckingConnectivity state variable
  // Add a variable to track whether sign-in is complete
  late Future<User?> signInFuture;
  Future<void> fetchNews() async {
    try {
      final fetchedArticles = await newsSource.getNews();
      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> markAsRead(NewsItem article) async {
    setState(() {
      readArticles.add(article);
    });
    // Persist read status, you can use SharedPreferences or any other local storage method here
  }

  @override
  void initState() {
    super.initState();
    newsSource = UPEINewsSource(client: http.Client());
    fetchNews();
    OfflineNewsManager.retrieveOfflineNewsFromStorage();
    // Call the anonymous sign-in method
    signInFuture = AuthService().signInAnonymously();
    // Add delay for checking connectivity
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isCheckingConnectivity = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPEI News'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: isCheckingConnectivity // Check if still checking connectivity
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
        ),
      )
          : isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
        ),
      )
          : Consumer<InternetConnectivityProvider>(
        builder: (context, internetConnectivity, _) {
          if (internetConnectivity.isConnected) {
            return NewsArticlesView(news: articles);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Looks like you\'re offline',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/offline');
                    },
                    child: Text('Check out your offline reads'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
