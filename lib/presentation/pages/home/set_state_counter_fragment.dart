import 'dart:math';

import 'package:flutter/material.dart';
import 'package:physiomobile_technical_assessment/core/theme/app_colors.dart';
import 'package:physiomobile_technical_assessment/data/models/bubble.dart';
import 'package:physiomobile_technical_assessment/presentation/widgets/custom_button.dart';

class SetStateCounterFragment extends StatefulWidget {
  const SetStateCounterFragment({super.key});

  @override
  State<SetStateCounterFragment> createState() =>
      _SetStateCounterFragmentState();
}

class _SetStateCounterFragmentState extends State<SetStateCounterFragment>
    with AutomaticKeepAliveClientMixin {
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter = (_counter - 1).clamp(0, 100));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.none,
          children: [
            _BouncingBubbles(
              bubbleCount: _counter,
              screenSize: Size(
                constraints.maxWidth,
                constraints.maxHeight - 100,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24.0),
              margin: const EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    onPressed: _counter > 0 ? _decrement : null,
                    icon: Icon(Icons.remove, color: AppColors.darkPrimary),
                  ),

                  Text(
                    "$_counter",
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  CustomButton(
                    onPressed: _increment,
                    icon: Icon(Icons.add, color: AppColors.darkPrimary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _BouncingBubbles extends StatefulWidget {
  final int bubbleCount;
  final Size screenSize;
  const _BouncingBubbles({required this.bubbleCount, required this.screenSize});

  @override
  State<_BouncingBubbles> createState() => __BouncingBubblesState();
}

class __BouncingBubblesState extends State<_BouncingBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();
  int _lastBubbleCount = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 16),
          )
          ..addListener(_update)
          ..repeat();

    _lastBubbleCount = widget.bubbleCount;
    _adjustBubbles();
  }

  void _update() {
    for (var bubble in _bubbles) {
      if (!bubble.isActive) continue;

      bubble.position += bubble.velocity;
      bubble.age += 1;

      if (bubble.position.dx - bubble.radius < 0 ||
          bubble.position.dx + bubble.radius > widget.screenSize.width) {
        bubble.velocity = Offset(-bubble.velocity.dx, bubble.velocity.dy);
      }
      if (bubble.position.dy - bubble.radius < 0 ||
          bubble.position.dy + bubble.radius > widget.screenSize.height) {
        bubble.velocity = Offset(bubble.velocity.dx, -bubble.velocity.dy);
      }
    }
    setState(() {});
  }

  void _adjustBubbles() {
    final count = widget.bubbleCount;

    if (count < _lastBubbleCount) {
      int removeCount = _lastBubbleCount - count;

      var activeBubbles = _bubbles.where((b) => b.isActive).toList();
      activeBubbles.sort((a, b) => b.number.compareTo(a.number));

      for (int i = 0; i < removeCount && i < activeBubbles.length; i++) {
        _bubbles.remove(activeBubbles[i]);
      }
    }

    if (count > _lastBubbleCount) {
      int addCount = count - _lastBubbleCount;
      int nextNumber =
          _bubbles.isEmpty
              ? 1
              : (_bubbles.map((b) => b.number).reduce(max) + 1);

      for (int i = 0; i < addCount; i++) {
        _bubbles.add(_createBubble(nextNumber + i));
      }
    }

    _bubbles.sort((a, b) => a.number.compareTo(b.number));
    for (int i = 0; i < _bubbles.length; i++) {
      _bubbles[i].number = i + 1;
    }

    _lastBubbleCount = count;
  }

  Bubble _createBubble(int number) {
    final radius = _random.nextDouble() * 20 + 15;
    final position = Offset(
      _random.nextDouble() * widget.screenSize.width,
      _random.nextDouble() * widget.screenSize.height,
    );
    final velocity = Offset(
      (_random.nextDouble() - 0.5) * 4,
      (_random.nextDouble() - 0.5) * 4,
    );
    final color = Colors.primaries[_random.nextInt(Colors.primaries.length)]
        .withAlpha(150);

    return Bubble(
      position: position,
      velocity: velocity,
      radius: radius,
      color: color,
      number: number,
      age: 0,
      isActive: true,
      fadeOutStart: 0,
    );
  }

  @override
  void didUpdateWidget(covariant _BouncingBubbles oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.bubbleCount != oldWidget.bubbleCount) {
      _adjustBubbles();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(_bubbles),
      size: widget.screenSize,
    );
  }
}

class _BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;

  _BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      double opacity = 1.0;
      if (bubble.age < 30) {
        opacity = bubble.age / 30;
      } else if (!bubble.isActive) {
        final fadeProgress = (bubble.age - bubble.fadeOutStart) / 30;
        opacity = 1.0 - fadeProgress.clamp(0.0, 1.0);
      }

      final glowPaint =
          Paint()
            ..color = bubble.color.withAlpha(opacity > 0.5 ? 100 : 0)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

      canvas.drawCircle(bubble.position, bubble.radius + 5, glowPaint);

      final paint =
          Paint()
            ..color = bubble.color.withAlpha(opacity > 0.5 ? 255 : 0)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(bubble.position, bubble.radius, paint);

      if (bubble.radius > 15) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: bubble.number.toString(),
            style: TextStyle(
              color: Colors.white.withAlpha((opacity > 0.5 ? 255 : 0)),
              fontSize: bubble.radius * 0.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          bubble.position -
              Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
