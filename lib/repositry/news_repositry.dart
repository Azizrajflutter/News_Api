import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';

class NewsRepositry {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String name) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${name}&apiKey=90ecaa890004427e84f2d2c13b837b0e';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Success////////////////////////');

      final data = await jsonDecode(response.body);

      print(data);
      return NewsChannelHeadlinesModel.fromJson(data);
    }
    throw Exception('Failled');
  }

  Future<CategoriesNewsModel> fetchNewsCatogoryApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=90ecaa890004427e84f2d2c13b837b0e';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Success////////////////////////');

      final data = await jsonDecode(response.body);

      print(data);
      return CategoriesNewsModel.fromJson(data);
    }
    throw Exception('Failled');
  }
}
