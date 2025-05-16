part of 'post_bloc.dart';

enum PostViewType { list, grid }

sealed class PostState extends Equatable {
  final PostViewType viewType;

  const PostState({this.viewType = PostViewType.list});

  @override
  List<Object> get props => [viewType];
}

final class PostInitial extends PostState {
  const PostInitial() : super(viewType: PostViewType.list);
}

final class PostLoading extends PostState {
  const PostLoading({super.viewType = PostViewType.list});
}

final class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded({required this.posts, super.viewType = PostViewType.list});

  @override
  List<Object> get props => [posts, viewType];
}

final class PostError extends PostState {
  final String message;

  const PostError({required this.message, super.viewType = PostViewType.list});

  @override
  List<Object> get props => [message, viewType];
}
