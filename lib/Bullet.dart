import 'package:bullet_hell/bullets.dart';
import 'package:flame/components.dart';

class Bullet1 extends SpriteAnimationComponent with HasGameRef, BulletsMixin {
  final SpriteAnimationComponent boss;
  final double movingDirection;

  Bullet1(this.boss, this.movingDirection) : super();

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    animation = await gameRef.loadSpriteAnimation(
        'boss_bullets.png',
        SpriteAnimationData.sequenced(
            texturePosition: Vector2.zero(),
            amount: 7,
            stepTime: 0.6,
            textureSize: Vector2(13, 13),
            loop: true));
    size = Vector2(26, 26);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    boss.priority = boss.priority++;
    moveWithAngle(movingDirection, 100 * dt);
    super.update(dt);
  }
}
