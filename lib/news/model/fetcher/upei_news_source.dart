import 'dart:typed_data';
import 'package:UPEI_NEWSAPP/news/model/fetcher/news_gen.dart';
import 'package:UPEI_NEWSAPP/news/model/model.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

// UPEINewsSource class responsible for fetching news from UPEI website
class UPEINewsSource implements NewsSourcer {
  final http.Client client; // HTTP client for making requests
  final Map<String, String> imageCache = {}; // Cache for storing image URLs

  // Constructor with optional HTTP client
  UPEINewsSource({required http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<NewsItem>> getNews() async {

    final response = await client.get(Uri.parse('https://www.upei.ca/feeds/news.rss')!);
    if (response.statusCode == 200) {

      final feed = RssFeed.parse(response.body);
      final articles = feed.items ?? [];
      // Fetch news items asynchronously
      final newsItems = await Future.wait(articles.map((rssItem) async {
        final imageUrl = await _getImageUrlFromDescription(rssItem.link!);
        final imageData = await _fetchImageData(imageUrl);
        return NewsItem(
          rssItem.hashCode.toString(),
          rssItem.title ?? '',
          _removeHtmlTags(rssItem.description),
          rssItem.pubDate ?? DateTime.now(),
          rssItem.dc?.creator ?? "",
          imageUrl,
          false,
          imageData: imageData,
        );
      }));
      return newsItems.toList(); // Convert the iterable to a list and return
    } else {
      throw Exception('Failed to load news'); // Throw an exception if failed to load news
    }
  }

  // Function to fetch image data from the given URL
  Future<Uint8List?> _fetchImageData(String imageUrl) async {
    final response = await client.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes; // Return the image data if request is successful
    }
    return null; // Return null if failed to fetch image data
  }

  // Function to extract image URL from the description of the news item
  Future<String> _getImageUrlFromDescription(String link) async {

    // Check if the image URL is already cached
    if (imageCache.containsKey(link)) {
      return imageCache[link]!;
    }

    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      dom.Element? imageElement = document.querySelector('.medialandscape img');
      String imageUrl = imageElement != null ? imageElement.attributes['src'] ?? '' : '';
      // Cache the image URL
      String links = "https://upei.ca/$imageUrl";
      imageCache[link] = links;

      return "https://upei.ca/$imageUrl"; // Return the extracted image URL
    }
    return ''; // Return an empty string if failed to extract image URL
  }
}

// Function to remove HTML tags from the given description
String _removeHtmlTags(String? description) {
  final document = parse(description);
  final String parsedDescription = parse(document.body?.text).documentElement?.text??"";
  return parsedDescription; // Return the description with HTML tags removed
}
