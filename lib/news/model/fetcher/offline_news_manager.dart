import 'dart:convert';
import 'package:UPEI_NEWSAPP/news/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OfflineNewsManager class responsible for managing offline news storage
class OfflineNewsManager {
  // List to store offline news articles
  static List<NewsItem> offlineNewsArticles = [];

  // Function to convert NewsItem object to JSON format
  static Map<String, dynamic> newsItemToJson(NewsItem newsItem) {
    return {
      'id': newsItem.id,
      'title': newsItem.title,
      'description': newsItem.body,
      'pubDate': newsItem.date.toIso8601String(),
      'author': newsItem.author,
      'imageUrl': newsItem.link,
      'isRead': newsItem.isRead,
      'imageData': newsItem.imageData != null ? base64Encode(newsItem.imageData!) : null,
    };
  }

  // Function to convert JSON format to NewsItem object
  static NewsItem jsonToNewsItem(Map<String, dynamic> json) {
    return NewsItem(
      json['id'] ?? '', // Handle null value for 'id'
      json['title'] ?? '', // Handle null value for 'title'
      json['description'] ?? '', // Handle null value for 'description'
      json['pubDate'] != null ? DateTime.tryParse(json['pubDate']) ?? DateTime.now() : DateTime.now(), // Handle null value for 'pubDate'
      json['author'] ?? '', // Handle null value for 'author'
      json['imageUrl'] ?? '', // Handle null value for 'imageUrl'
      json['isRead'] ?? false, // Handle null value for 'isRead'
      imageData: json['imageData'] != null ? base64Decode(json['imageData']) : null, // Handle null value for 'imageData'
    );
  }

  // Function to save offline news articles to local storage
  static Future<void> saveOfflineNewsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> newsItemsJson = [];
    for (final newsItem in offlineNewsArticles) {
      newsItemsJson.add(newsItemToJson(newsItem));
    }
    final json = jsonEncode(newsItemsJson);
    await prefs.setString('offlineNews', json);
  }

  // Function to retrieve offline news articles from local storage
  static Future<void> retrieveOfflineNewsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('offlineNews');
    if (json != null) {
      final List<dynamic> newsItemsJson = jsonDecode(json);
      offlineNewsArticles = newsItemsJson.map((itemJson) => jsonToNewsItem(itemJson)).toList();
    }
  }

  // Function to add a news item to offline storage
  static void addOfflineNews(NewsItem newsItem) {
    if (!offlineNewsArticles.contains(newsItem)) {
      offlineNewsArticles.add(newsItem);
      saveOfflineNewsToStorage(); // Save the updated list to local storage
    }
  }

  // Function to remove a news item from offline storage
  static void removeOfflineNews(NewsItem newsItem) {
    offlineNewsArticles.remove(newsItem);
    saveOfflineNewsToStorage(); // Save the updated list to local storage
  }
}
