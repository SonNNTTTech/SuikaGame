import 'package:flutter/material.dart';

enum BallLevel {
  ball1(2, Colors.red, 1),
  ball2(2.5, Colors.grey, 2),
  ball3(3, Colors.purple, 4),
  ball4(3.5, Colors.orange, 8),
  ball5(4, Colors.blue, 16),
  ball6(5, Colors.green, 32),
  ball7(6, Colors.yellow, 64),
  ball8(7, Colors.lightGreenAccent, 128),
  ball9(8, Colors.blueAccent, 256),
  ball10(9, Colors.yellowAccent, 512),
  ball11(10, Colors.greenAccent, 1024),
  ;

  final double radius;
  final Color color;
  final int score;
  const BallLevel(this.radius, this.color, this.score);

  BallLevel getNextBall() {
    switch (this) {
      case ball1:
        return ball2;
      case ball2:
        return ball3;
      case ball3:
        return ball4;
      case ball4:
        return ball5;
      case ball5:
        return ball6;
      case ball6:
        return ball7;
      case ball7:
        return ball8;
      case ball8:
        return ball9;
      case ball9:
        return ball10;
      case ball10:
        return ball11;
      case ball11:
        return ball1;
      default:
        return ball1;
    }
  }
}

enum GameState {
  playing,
  gameOver,
}
