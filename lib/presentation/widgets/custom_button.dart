import 'package:flutter/material.dart';
import 'package:physiomobile_technical_assessment/core/theme/app_colors.dart';
import 'package:physiomobile_technical_assessment/presentation/widgets/inner_shadow_painter.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? icon;

  const CustomButton({super.key, this.onPressed, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color:
              onPressed != null
                  ? AppColors.solidPurple
                  : AppColors.solidDarkBlue,
          borderRadius: BorderRadius.circular(100),
          border: Border.lerp(
            Border.all(color: AppColors.solidPink, width: 0.8),
            Border.all(color: AppColors.solidLightPurple, width: 0.5),
            0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 4,
              offset: Offset(4, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: (icon != null) ? icon : const SizedBox(),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: InnerShadowPainter(
                  shadowColor: AppColors.solidPurple.withAlpha(182),
                  blur: 10,
                  offset: Offset(-4, -4),
                  borderRadius: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
