import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:suika_game/game_vmd.dart';
import 'package:get/get.dart';
import 'package:suika_game/shared/enum.dart';

import 'ball.dart';
import 'death_line.dart';
import 'wall.dart';

class SuikaGame extends Forge2DGame with TapCallbacks {
  double highestBallY = 99;
  late Ball pendingBall;
  late double topY;
  late double deathY;
  bool isGeneratingBall = false;
  late GameVmd gameVmd;
  SuikaGame() : super(gravity: Vector2(0, 98));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameVmd = Get.find<GameVmd>();
    gameVmd.game = this;
    camera.viewport.add(FpsTextComponent());
    topY = camera.visibleWorldRect.top + 6;
    deathY = camera.visibleWorldRect.top + 12;
    createFirstBall();
    world.addAll(createWalls());
    world.add(DeathLine());
  }

  void createFirstBall() {
    pendingBall = gameVmd.getNextBall(initialPosition: Vector2(0, topY));
    world.add(pendingBall);
  }

  @override
  void update(double dt) {
    super.update(dt);
    calculateHighestBall();
  }

  List<Component> createWalls() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();

    return [
      Wall(topRight, bottomRight),
      Wall(bottomLeft, bottomRight),
      Wall(topLeft, bottomLeft),
    ];
  }

  void calculateHighestBall() {
    double temp = 99;
    for (final component in world.children) {
      if (component is Ball && component.isCalculateHigh) {
        if (highestBallY - component.position.y < -15) {
          component.isCalculateHigh = false;
        }
        if (component.position.y < temp) {
          temp = component.position.y;
        }
      }
    }
    if (highestBallY != temp) {
      highestBallY = temp;
      if (highestBallY < deathY) gameVmd.gameOver();
    }
  }

  void newGame() {
    highestBallY = 99;
    for (final component in world.children) {
      if (component is Ball) {
        component.removeFromParent();
      }
    }
    resumeEngine();
    createFirstBall();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isGeneratingBall) return;
    isGeneratingBall = true;
    final screenX = screenToWorld(event.localPosition).x;
    pendingBall.startFalling(Vector2(screenX, topY));
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      isGeneratingBall = false;
      if (gameVmd.gameState.value == GameState.gameOver) return;
      final newBall =
          gameVmd.getNextBall(initialPosition: Vector2(screenX, topY));
      pendingBall = newBall;
      world.add(newBall);
    });
  }
}
