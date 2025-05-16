import 'package:physiomobile_technical_assessment/data/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<Post>> getCachedPosts();
  Future<void> cachePosts(List<Post> posts);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Post>> getCachedPosts() async {
    final jsonString = sharedPreferences.getString('CACHED_POSTS');
    if (jsonString != null) {
      return postFromJson(jsonString);
    } else {
      throw Exception('No cached data found');
    }
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    await sharedPreferences.setString('CACHED_POSTS', postToJson(posts));
  }
}
