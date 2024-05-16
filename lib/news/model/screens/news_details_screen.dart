import 'package:UPEI_NEWSAPP/news/model/model.dart';
import 'package:UPEI_NEWSAPP/news/model/screens/comment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;


  const NewsDetailScreen({Key? key, required this.newsItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userId = FirebaseAuth.instance.currentUser?.uid; // Access the user ID
    print(userId);
    return Scaffold(
      appBar: AppBar(
        title: Text('UPEI News Story'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: Text(
                      newsItem.title,
                      style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Image.memory(
                  newsItem.imageData!,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  newsItem.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  DateFormat('yyyy-MM-dd').format(newsItem.date),
                  textAlign: TextAlign.center,
                ),
                Text(newsItem.author, textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentsScreen(newsItem: newsItem, userId: userId!)), // Pass the userId to CommentsScreen
                    );
                  },
                  child: Text('View/Add Comments'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
