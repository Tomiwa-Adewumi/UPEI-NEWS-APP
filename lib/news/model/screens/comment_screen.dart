import 'package:UPEI_NEWSAPP/comments.dart';
import 'package:UPEI_NEWSAPP/news/model/fetcher/comment_handler.dart';
import 'package:UPEI_NEWSAPP/news/model/news_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CommentsScreen extends StatefulWidget {
  final NewsItem newsItem;
  final String userId;

  const CommentsScreen({Key? key, required this.newsItem, required this.userId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _publicCommentController = TextEditingController();
  final TextEditingController _privateCommentController = TextEditingController();


  String? _userId = FirebaseAuth.instance.currentUser?.uid;


  @override
  void initState() {
    super.initState();
    print("i am here ${_userId}");
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Public'),
              Tab(text: 'Private'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCommentList(_publicCommentController, false),
            _buildCommentList(_privateCommentController, true),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList(TextEditingController controller, bool isPrivate) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Comment>>(
            future: fetchComments(isPrivate), // Call the fetchComments method
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final comments = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment.text),
                      //subtitle: Text(comment.userId),
                      // Add more UI elements as needed
                    );
                  },
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your comment...',
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _submitComment(controller, isPrivate),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<Comment>> fetchComments(bool isPrivate) async {
    try {
      if (_userId != null) {
        final publicComments = await CommentHandler().getComments(widget.newsItem, _userId!, isPrivate);
        return publicComments;
      } else {
        // Return an empty list if userId is not initialized yet
        return [];
      }
    } catch (e) {
      print('Error fetching comments: $e');
      return []; // Return empty list in case of error
    }
  }

  Future<void> _submitComment(TextEditingController controller, bool isPrivate) async {
    final text = controller.text.trim();

    if (text.isNotEmpty) {
      if (widget.userId.isNotEmpty) {
        await _addCommentAndFetch(isPrivate, text, controller);
      } else {
        print('User ID is not present'); // Handle the case where user ID is not present
      }
    }
  }


  Future<void> _addCommentAndFetch(bool isPrivate, String text, TextEditingController controller) async {
    await CommentHandler().addComment(widget.newsItem, _userId!, text, isPrivate);
    controller.clear(); // Clear the text field after submitting the comment
    setState(() {
      // Empty setState callback
    });
    // Refetch comments after adding new comment
    await fetchComments(isPrivate);
  }
}
