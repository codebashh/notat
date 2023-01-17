import 'dart:math';

import 'package:flutter/material.dart';

List<Color> colors = [
  Colors.blue,
  Colors.orange,
  Colors.red,
  Colors.pink,
  Colors.yellow,
  Colors.purple,
  Colors.green,
];

Color getRandomColor() {
  Random rand = Random();
  return colors[rand.nextInt(7)];
}
