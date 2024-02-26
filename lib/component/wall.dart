import 'package:flame_forge2d/flame_forge2d.dart';

class Wall extends BodyComponent with ContactCallbacks {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 1);
    final bodyDef = BodyDef(
      position: Vector2.zero(),
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
