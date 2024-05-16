import 'package:UPEI_NEWSAPP/news/model/model.dart';
import 'package:UPEI_NEWSAPP/news/model/screens/screens.dart';
import 'package:flutter/material.dart';



// NewsTile widget to display a tile for a news item
class NewsTile extends StatefulWidget {
  final NewsItem newsItem;

  const NewsTile({Key? key, required this.newsItem}) : super(key: key);

  static List<NewsItem> readNewsArticles = []; // List to store read news articles

  // Function to add a read news item to the list
  static void addReadNewsItem(NewsItem item) {
    item.changeReadState(); // Change the read state of the news item
    if (!readNewsArticles.contains(item)) {
      readNewsArticles.add(item); // Add the news item to the list if not already present
    }
  }

  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  bool isBookmarked = false; // Variable to track bookmark state

  @override
  void initState() {
    super.initState();
    isBookmarked = OfflineNewsManager.offlineNewsArticles.contains(widget.newsItem); // Check if news item is bookmarked
  }

  // Function to toggle the bookmark state
  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    if (isBookmarked) {
      OfflineNewsManager.addOfflineNews(widget.newsItem); // Add news item to offline storage
    } else {
      OfflineNewsManager.removeOfflineNews(widget.newsItem); // Remove news item from offline storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Adjust the height of the GestureDetector as needed
      child: GestureDetector(
        onTap: () {
          widget.newsItem.changeReadState();
          NewsTile.addReadNewsItem(widget.newsItem); // Add news item to read list
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(newsItem: widget.newsItem), // Navigate to NewsDetailScreen with the news item
            ),
          );
        },
        child: Card(
          elevation: 4, // Add elevation for a shadow effect
          child: Padding(
            padding: const EdgeInsets.all(2.0), // Add padding for spacing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 70, // Adjust the height of the image container as needed
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Placeholder or empty container for image
                      Container(
                        color: Colors.grey[300],
                        child: widget.newsItem.imageData != null
                            ? Image.memory(
                          widget.newsItem.imageData!,
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      // Loading indicator
                      if (widget.newsItem.imageData == null)
                        const CircularProgressIndicator(), // Display a loading indicator while image is loading
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible( // Add Flexible to prevent overflow
                      child: Text(
                        widget.newsItem.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        _toggleBookmark(); // Toggle bookmark state
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
