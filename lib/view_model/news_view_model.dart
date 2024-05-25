


import 'package:damn_news/models/news_channel_headlines_model.dart';
import 'package:damn_news/repository/news_repository.dart';
import 'package:damn_news/models/categories_new_model.dart';
class NewsViewModel{

  final _rep = NewsRepository();


  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName) async{
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response ;
  }
  Future<CategoriesNewsModel> fetchNewsCategoriesApi(String category) async{
    final response = await _rep.fetchNewsCategoriesApi(category);
    return response ;
  }

}


