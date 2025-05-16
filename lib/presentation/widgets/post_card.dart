import 'package:flutter/material.dart';
import 'package:physiomobile_technical_assessment/core/theme/app_colors.dart';
import 'package:physiomobile_technical_assessment/data/models/post.dart';
import 'package:physiomobile_technical_assessment/presentation/widgets/inner_shadow_painter.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.solidDarkBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.lerp(
          Border.all(color: AppColors.solidPink, width: 0.8),
          Border.all(color: AppColors.solidLightPurple, width: 0.5),
          0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 4,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTag(
                      'User ID: ${post.userId}',
                      AppColors.solidPurple,
                      AppColors.darkPrimary,
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      'Post ID: ${post.id}',
                      AppColors.solidPink.withAlpha(100),
                      AppColors.darkPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  post.body,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkSecondary,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: InnerShadowPainter(
                shadowColor: AppColors.solidPurple.withAlpha(182),
                blur: 10,
                offset: const Offset(-4, -4),
                borderRadius: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
