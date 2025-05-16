import 'package:http/http.dart' as http;
import 'package:physiomobile_technical_assessment/core/utils/network/api_exception.dart';
import 'package:physiomobile_technical_assessment/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await client.get(
        Uri.parse(
          '${String.fromEnvironment('JSON_PLACEHOLDER_API_URL')}/posts',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return postFromJson(response.body);
      } else {
        throw ApiException(
          message: 'Failed to load posts',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
