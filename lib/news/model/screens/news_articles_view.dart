


import 'package:UPEI_NEWSAPP/news/model/screens/screens.dart';
import 'package:flutter/material.dart';
import '../news_item.dart';


// NewsArticlesView widget to display a grid view of news articles
class NewsArticlesView extends StatelessWidget {
  final List<NewsItem> news; // List of news items

  // Constructor to initialize the list of news items
  NewsArticlesView({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('UPEI News'), // Title of the app bar
        ),
        backgroundColor: Colors.purpleAccent, // Background color of the app bar
      ),
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2, // Number of items per row in the grid view
            padding: EdgeInsets.all(16.0), // Padding around the grid view
            mainAxisSpacing: 16.0, // Spacing between rows
            crossAxisSpacing: 16.0, // Spacing between columns
            children: List.generate(news.length, (index) {
              return NewsTile(
                newsItem: news[index], // Display each news item using NewsTile widget
              );
            }),
          ),
          ConnectionAlert(), // Display connection alert if offline
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/offline'); // Navigate to offline articles screen
        },
        child: Icon(Icons.download), // Icon for the floating action button
        tooltip: 'Offline Articles', // Tooltip for the floating action button
      ),
    );
  }
}
