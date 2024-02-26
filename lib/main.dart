import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'component/game.dart';
import 'game_vmd.dart';

void main() {
  Get.put(GameVmd());
  final vmd = Get.find<GameVmd>();
  runApp(
    GetMaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              const GameWidget.controlled(
                gameFactory: SuikaGame.new,
              ),
              Positioned(
                  right: 16,
                  child: Obx(() => Text(
                        'Score: ${vmd.score.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 28),
                      ))),
              Positioned(
                left: 16,
                child: Row(
                  children: [
                    const Text(
                      'Next:',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Obx(
                      () => Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: vmd.nextBall.value.color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
