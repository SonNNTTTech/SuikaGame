import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class DeathLine extends PositionComponent
    with HasGameReference<SuikaGame>, HasPaint, HasVisibility {
  late Rect _rect;
  bool isShow = false;
  Timer? timer;
  @override
  void update(double dt) {
    super.update(dt);
    if (game.highestBallY < 0 && !isShow) {
      isShow = true;
      timer = Timer.periodic(const Duration(milliseconds: 1520), (timer) {
        blink();
      });
    }
    if (game.highestBallY > 0 && isShow) {
      isShow = false;
      timer?.cancel();
    }
  }

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    _rect = Rect.fromLTRB(game.camera.visibleWorldRect.left + 1, game.deathY,
        game.camera.visibleWorldRect.right - 1, game.deathY + 1);
    const gradient = LinearGradient(
      colors: [
        Colors.red,
        Colors.green,
        Colors.yellow,
        Colors.green,
        Colors.red,
      ],
    );
    paint = Paint()..shader = gradient.createShader(_rect);
    return super.onLoad();
  }

  Future blink() async {
    add(
      OpacityEffect.to(
        0.2,
        EffectController(duration: 0.75),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 760));
    add(
      OpacityEffect.fadeIn(
        EffectController(duration: 0.75),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isShow) canvas.drawRect(_rect, paint);
  }
}
