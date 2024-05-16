
import 'package:UPEI_NEWSAPP/news/model/fetcher/fetcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('UPEINewsSource', () {
    late http.Client client;
    late UPEINewsSource upeiNewsSource;

    setUp(() {
      client = MockClient((request) async {
        // Mocking the response for the RSS feed request
        if (request.url.toString() == 'https://www.upei.ca/feeds/news.rss') {
          return http.Response(
            _getMockRssFeed(), // Provide a mock RSS feed response
            200,
          );
        }
        // Mocking other requests if necessary
        return http.Response('', 404);
      });
      upeiNewsSource = UPEINewsSource(client: client);
    });

    tearDown(() {
      client.close(); // Close the client after each test
    });
    test('getNews should return a list of news items on successful call', () async {
      final response = http.Response(
        _getMockRssFeed(), // Provide a mock RSS feed response
        200,
      );
      final client = MockClient((request) async {
        // Mocking the response for the RSS feed request
        if (request.url.toString() == 'https://www.upei.ca/feeds/news.rss') {
          return response;
        }
        // Mocking other requests if necessary
        return http.Response('', 404);
      });
      final upeiNewsSource = UPEINewsSource(client: client);

      final newsItems = await upeiNewsSource.getNews();

      // Assert that the returned list of news items is not empty
      expect(newsItems, isNotEmpty);
      // Add more assertions as needed
    });

    test('getNews should throw an exception on failed call', () async {
      final client = MockClient((request) async {
        // Simulating a failed request
        return http.Response('', 404);
      });
      final upeiNewsSource = UPEINewsSource(client: client);

      // Expect an exception to be thrown when calling getNews
      expect(() async => await upeiNewsSource.getNews(), throwsException);
    });
    test('getNews should return a list of news items', () async {
      final newsItems = await upeiNewsSource.getNews();

      // Add your assertions here to verify the returned news items
      expect(newsItems, isNotEmpty);
      // Add more assertions as needed
    });
  });
}

// Mock RSS feed data for testing purposes
String _getMockRssFeed() {
  return '''
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0">
    <channel>
      <item>
        <title>News Title 1</title>
        <description>News Description 1</description>
        <link>https://example.com/news1</link>
      </item>
      <item>
        <title>News Title 2</title>
        <description>News Description 2</description>
        <link>https://example.com/news2</link>
      </item>
    </channel>
  </rss>
  ''';
}
