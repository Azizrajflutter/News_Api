import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repositry/news_repositry.dart';

class NewsViewModel {
  final _rep = NewsRepositry();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String name) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(name);
    return response;
  }

  Future<CategoriesNewsModel> fetchNewsCatogoryApi(String category) async {
    final response = await _rep.fetchNewsCatogoryApi(category);
    return response;
  }
}
