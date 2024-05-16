import 'package:UPEI_NEWSAPP/news/model/model.dart';
import 'package:UPEI_NEWSAPP/news/model/screens/screens.dart';
import 'package:flutter/material.dart';
import '../fetcher/offline_news_manager.dart';

// OfflineArticlesScreen widget to display offline news articles
class OfflineArticlesScreen extends StatelessWidget {
  const OfflineArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<NewsItem> offlineNews = OfflineNewsManager.offlineNewsArticles; // Retrieve offline news articles

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('UPEI News Offline'), // Title of the app bar
        ),
        backgroundColor: Colors.purpleAccent, // Background color of the app bar
      ),
      body: GridView.count(
        crossAxisCount: 2, // Number of items per row in the grid view
        padding: const EdgeInsets.all(16.0), // Padding around the grid view
        mainAxisSpacing: 16.0, // Spacing between rows
        crossAxisSpacing: 16.0, // Spacing between columns
        children: List.generate(offlineNews.length, (index) {
          return NewsTile(
            newsItem: offlineNews[index], // Pass the NewsItem to NewsTile
          );
        }),
      ),
    );
  }
}
