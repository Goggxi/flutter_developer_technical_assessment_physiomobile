import 'package:physiomobile_technical_assessment/core/utils/network/network_info.dart';
import 'package:physiomobile_technical_assessment/data/datasources/post_local_data_source.dart';
import 'package:physiomobile_technical_assessment/data/datasources/post_remote_datasource.dart';
import 'package:physiomobile_technical_assessment/data/models/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<void> refreshPosts();
}

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Post>> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts();
        localDataSource.cachePosts(remotePosts);
        return remotePosts;
      } catch (e) {
        return localDataSource.getCachedPosts();
      }
    } else {
      return localDataSource.getCachedPosts();
    }
  }

  @override
  Future<void> refreshPosts() async {
    if (await networkInfo.isConnected) {
      final remotePosts = await remoteDataSource.getPosts();
      await localDataSource.cachePosts(remotePosts);
    }
  }
}
