import 'dart:typed_data'; // Import for Uint8List
import 'package:UPEI_NEWSAPP/comments.dart';
import 'package:equatable/equatable.dart'; // Import Equatable for equality comparison

// Simple class to represent NewsItems
class NewsItem extends Equatable {
  final String id;
  // Add fields for comments
  List<Comment> privateComments = [];
  List<Comment> publicComments = [];

  final String title; // Title of the news item
  final String body; // Body/content of the news item
  final DateTime date; // Date of the news item
  final String author; // Author of the news item
  final String link; // Link/URL of the news item
  bool isRead; // Flag indicating if the news item has been read
  Uint8List? imageData; // Image data of the news item (optional)

  // Construct a news item
  NewsItem(this.id,this.title, this.body, this.date, this.author, this.link, this.isRead, {this.imageData});

  // Return a copy of the newsItem but with the read flag set to true
  NewsItem readVersion() {
    return NewsItem(id,title, body, date, author, link, true, imageData: imageData);
  }

  // Method to change the read state of the news item
  void changeReadState() {
    if (!isRead) {
      isRead = true;
    }
  }

  // Properties involved in the override for == and hashCode
  @override
  List<Object?> get props => [title, body, date, author, isRead];

  // Equatable library converts this object to a string
  @override
  bool get stringify => true;
}
