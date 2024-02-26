import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:suika_game/shared/enum.dart';
import 'package:suika_game/widget/dialog_wrapper.dart';

import 'component/ball.dart';
import 'component/game.dart';

class GameVmd extends GetxController {
  late SuikaGame game;

  final gameState = GameState.playing.obs;
  final score = 0.obs;
  late Rx<BallLevel> nextBall;
  final List<BallLevel> startBall = [
    BallLevel.ball1,
    BallLevel.ball2,
    BallLevel.ball3,
    BallLevel.ball4,
    BallLevel.ball5,
  ];
  @override
  void onInit() {
    nextBall = startBall.random().obs;
    super.onInit();
  }

  void gameOver() {
    gameState.value = GameState.gameOver;
    game.pauseEngine();
    Get.dialog(
      Dialog(
        child: DialogWrapper(
          child: Wrap(
            direction: Axis.vertical,
            children: [
              const Text(
                "Game Over",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Your score is $score"),
              ElevatedButton(
                onPressed: newGame,
                child: const Text("New game"),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void newGame() {
    Get.back();
    gameState.value = GameState.playing;
    score.value = 0;
    game.newGame();
  }

  Ball getNextBall({Vector2? initialPosition, bool? initActive}) {
    final temp = nextBall.value;
    nextBall.value = startBall.random();
    return Ball(
      ballLevel: temp,
      initialPosition: initialPosition,
      initActive: initActive ?? false,
    );
  }
}
