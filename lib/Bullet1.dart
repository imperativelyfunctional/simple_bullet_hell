import 'package:flame/components.dart';

class Bullet1 extends SpriteAnimationComponent with HasGameRef {
  Bullet1();

  @override
  Future<void>? onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
        'boss_bullets.png',
        SpriteAnimationData.sequenced(
            amount: 7, stepTime: 0.6, textureSize: Vector2(13, 13)));
    return super.onLoad();
  }
}
