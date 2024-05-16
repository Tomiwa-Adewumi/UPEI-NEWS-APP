///News Generator
import 'package:UPEI_NEWSAPP/news/model/model.dart';


///Source the news
abstract class NewsSourcer {

  ///Retrieve a List of NewsItems
  Future<List<NewsItem>> getNews();

}