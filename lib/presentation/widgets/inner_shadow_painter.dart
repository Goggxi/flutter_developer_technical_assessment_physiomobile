import 'package:flutter/material.dart';

class InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blur;
  final Offset offset;
  final double borderRadius;

  InnerShadowPainter({
    required this.shadowColor,
    required this.blur,
    required this.offset,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final outerPaint =
        Paint()
          ..color = shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    // final innerPath =
    //     Path()..addRRect(
    //       RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
    //     );

    final fullRect = Rect.fromLTWH(
      -size.width,
      -size.height,
      size.width * 3,
      size.height * 3,
    );
    final outerPath =
        Path()
          ..addRect(fullRect)
          ..addRRect(
            RRect.fromRectAndRadius(
              rect.shift(offset),
              Radius.circular(borderRadius),
            ),
          )
          ..fillType = PathFillType.evenOdd;

    canvas.saveLayer(rect, Paint());
    canvas.drawPath(outerPath, outerPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
