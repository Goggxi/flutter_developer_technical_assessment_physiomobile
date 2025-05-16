import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:physiomobile_technical_assessment/core/theme/app_colors.dart';
import 'package:physiomobile_technical_assessment/data/models/post.dart';
import 'package:physiomobile_technical_assessment/di.dart';
import 'package:physiomobile_technical_assessment/presentation/bloc/post/post_bloc.dart';
import 'package:physiomobile_technical_assessment/presentation/widgets/post_card.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostBloc _postBloc = sl();

  @override
  void initState() {
    super.initState();
    _postBloc.add(FetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.solidDarkBlue,
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkPrimary,
        elevation: 0,
        actions: [
          BlocBuilder<PostBloc, PostState>(
            bloc: _postBloc,
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.viewType == PostViewType.list
                      ? Icons.grid_view
                      : Icons.list,
                  color: AppColors.darkPrimary,
                ),
                onPressed: () {
                  _postBloc.add(
                    ChangeViewTypeEvent(
                      state.viewType == PostViewType.list
                          ? PostViewType.grid
                          : PostViewType.list,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          BlocBuilder<PostBloc, PostState>(
            bloc: _postBloc,
            builder: (context, state) {
              if (state is PostInitial) {
                return _buildEmptyState('Tap refresh to load posts');
              } else if (state is PostLoading) {
                return _buildLoadingState();
              } else if (state is PostLoaded) {
                return _buildPostsView(state.posts, state.viewType);
              } else if (state is PostError) {
                return _buildErrorState(state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.solidPurple.withAlpha(100),
            AppColors.solidDarkBlue.withAlpha(50),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.5],
        ),
      ),
    );
  }

  Widget _buildPostsView(List<Post> posts, PostViewType viewType) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostBloc>().add(RefreshPostsEvent());
      },
      backgroundColor: AppColors.solidPurple,
      color: AppColors.darkPrimary,
      child:
          posts.isEmpty
              ? _buildEmptyState('No posts available')
              : viewType == PostViewType.list
              ? _buildPostList(posts)
              : _buildPostGrid(posts),
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return RefreshIndicator(
      onRefresh: () async {
        _postBloc.add(RefreshPostsEvent());
      },
      backgroundColor: AppColors.solidPurple,
      color: AppColors.darkPrimary,
      child:
          posts.isEmpty
              ? _buildEmptyState('No posts available')
              : ListView.builder(
                itemCount: posts.length,
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(post: post);
                },
              ),
    );
  }

  Widget _buildPostGrid(List<Post> posts) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(post: post, isGridItem: true);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.solidDarkBlue.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.solidLightPurple.withAlpha(100)),
        ),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.darkSecondary, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.solidDarkBlue.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.solidLightPurple.withAlpha(100)),
        ),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.solidPink),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: AppColors.solidDarkBlue,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkError.withAlpha(100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.darkError,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: $message',
                  style: const TextStyle(
                    color: AppColors.darkSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _postBloc.add(FetchPostsEvent()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.solidPurple,
                    foregroundColor: AppColors.darkPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.solidPink, AppColors.solidPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.solidPink.withAlpha(100),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _postBloc.add(RefreshPostsEvent()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.refresh_rounded, color: AppColors.darkPrimary),
      ),
    );
  }
}
