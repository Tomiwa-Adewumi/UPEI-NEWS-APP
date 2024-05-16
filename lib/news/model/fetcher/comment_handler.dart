import 'package:UPEI_NEWSAPP/comments.dart';
import 'package:UPEI_NEWSAPP/news/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class CommentHandler {
  Future<List<Comment>> fetchComments(NewsItem newsItem, String userId) async {
    try {
      final publicComments = await getComments(newsItem, userId, false);
      final privateComments = await getComments(newsItem, userId, true);

      // Return both public and private comments
      return [...publicComments, ...privateComments];
    } catch (e) {
      // Handle error
      print('Error fetching comments: $e');
      return []; // Return empty list in case of error
    }
  }

  Future<void> addComment(NewsItem newsItem, String userId, String text, bool isPrivate) async {
    final collectionName = isPrivate ? 'privateComments' : 'publicComments';
    await FirebaseFirestore.instance
        .collection('news')
        .doc(newsItem.id)
        .collection(collectionName)
        .add({
      'userId': userId,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  Future<List<Comment>> getComments(NewsItem newsItem, String userId, bool isPrivate) async {
    final collectionName = isPrivate ? 'privateComments' : 'publicComments';
    final snapshot = await FirebaseFirestore.instance
        .collection('news')
        .doc(newsItem.id)
        .collection(collectionName)
        .get();
    return snapshot.docs.map((doc) => Comment(
      doc['userId'],
      doc['text'],
      (doc['timestamp'] as Timestamp).toDate(),
    )).toList();
  }
}
