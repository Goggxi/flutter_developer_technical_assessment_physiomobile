import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:physiomobile_technical_assessment/data/models/post.dart';
import 'package:physiomobile_technical_assessment/data/repositories/post_repository_impl.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<ChangeViewTypeEvent>(_onChangeViewType);
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading(viewType: state.viewType));
    try {
      final posts = await repository.getPosts();
      emit(PostLoaded(posts: posts, viewType: state.viewType));
    } catch (e) {
      emit(PostError(message: e.toString(), viewType: state.viewType));
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading(viewType: state.viewType));
    try {
      await repository.refreshPosts();
      final posts = await repository.getPosts();
      emit(PostLoaded(posts: posts, viewType: state.viewType));
    } catch (e) {
      emit(PostError(message: e.toString(), viewType: state.viewType));
    }
  }

  void _onChangeViewType(ChangeViewTypeEvent event, Emitter<PostState> emit) {
    if (state is PostLoaded) {
      emit(
        PostLoaded(
          posts: (state as PostLoaded).posts,
          viewType: event.viewType,
        ),
      );
    } else {
      emit(PostInitial());
    }
  }
}
