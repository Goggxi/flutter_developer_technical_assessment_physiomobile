part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

final class FetchPostsEvent extends PostEvent {}

final class RefreshPostsEvent extends PostEvent {}
