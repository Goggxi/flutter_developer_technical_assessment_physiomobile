import 'package:flutter/material.dart';

class Bubble {
  Offset position;
  Offset velocity;
  double radius;
  Color color;
  int number;
  int age;
  bool isActive;
  int fadeOutStart;

  Bubble({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.number,
    required this.age,
    required this.isActive,
    required this.fadeOutStart,
  });
}
