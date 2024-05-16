import '../model.dart';
import 'package:http/http.dart' as http;



/// Singleton pattern for holding News articles
class NewsDatabase {
  static final NewsDatabase _singleton = NewsDatabase._internal();

  // Change the source of the news here
  final NewsSourcer _news = UPEINewsSource(client: http.Client());

  factory NewsDatabase() {
    return _singleton;
  }

  // Private named constructor
  NewsDatabase._internal();

  /// Get all of the news items
  Future<List<NewsItem>> getNewsItems() {
    return _news.getNews();
  }
}
