import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:get/instance_manager.dart';
import 'package:suika_game/game_vmd.dart';
import 'package:suika_game/shared/enum.dart';

class Ball extends BodyComponent with ContactCallbacks {
  final BallLevel ballLevel;
  Vector2? initialPosition;
  final bool initActive;
  bool isMerged = false;

  ///Is this ball need to calculate highest high
  bool isCalculateHigh;
  Ball({
    this.initialPosition,
    required this.ballLevel,
    this.initActive = false,
    this.isCalculateHigh = false,
  });
  @override
  Body createBody() {
    final fixtureDef = FixtureDef(
      CircleShape()..radius = ballLevel.radius,
      friction: 1,
    );
    paint.color = ballLevel.color;
    final bodyDef = BodyDef(
      position: initialPosition,
      type: initActive ? BodyType.dynamic : BodyType.static,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    isCalculateHigh = true;
    if (other is Ball) {
      if (other.ballLevel == ballLevel) {
        if (!isMerged) {
          isMerged = true;
          if (!other.isMerged) {
            world.add(Ball(
                ballLevel: ballLevel.getNextBall(),
                initialPosition: (position + other.position) / 2,
                initActive: true,
                isCalculateHigh: true));
            Get.find<GameVmd>().score.value += ballLevel.score;
          }
        }
        removeFromParent();
      }
    }
  }

  void startFalling(Vector2 moveTo) {
    body.setTransform(moveTo, angle);
    body.setType(BodyType.dynamic);
  }
}
