import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

import 'Bullet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  var bulletHell = BulletHell();
  runApp(GameWidget(game: bulletHell));
}

late Vector2 viewPortSize;

class BulletHell extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    viewPortSize = size;
    camera.viewport = FixedResolutionViewport(size);

    await addParallaxBackground();
    await addBoss();
  }

  Future<void> addBoss() async {
    var imageSize = Vector2(101, 64);
    final running = await loadSpriteAnimation(
      'boss.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: imageSize,
        stepTime: 0.5,
      ),
    );

    var boss = SpriteAnimationComponent(
        priority: 1,
        animation: running,
        anchor: Anchor.center,
        size: imageSize,
        angle: pi,
        position: Vector2(size.x / 2.0, -10),
        scale: Vector2(0.5, 0.5));

    boss.add(SequenceEffect([
      MoveEffect.to(
          Vector2(size.x / 2.0, 500),
          EffectController(
              duration: 3, infinite: false, curve: Curves.easeInCubic)),
      MoveEffect.to(
          Vector2(size.x / 2.0, 300),
          EffectController(
              duration: 2, infinite: false, curve: Curves.easeInExpo))
    ], infinite: false));

    async.Timer.periodic(const Duration(seconds: 5), (timer) {
      async.Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (timer.tick == 15) {
          timer.cancel();
        }
        for (int i = 0; i < 11; i++) {
          var other = (i % 11);
          var bullet = Bullet1(boss, (pi / 180) * other * 18)
            ..position = Vector2(boss.width / 2, boss.height / 2);
          boss.add(bullet);

          var bullet2 = Bullet1(boss, (-pi / 180) * other * 18)
            ..position = Vector2(boss.width / 2, boss.height / 2);
          boss.add(bullet2);
        }
      });
    });

    add(boss);
  }

  Future<void> addParallaxBackground() async {
    final layerInfo = {
      'background_1.png': 6.0,
      'background_2.png': 8.5,
      'background_3.png': 12.0,
      'background_4.png': 20.5,
    };

    final layers = layerInfo.entries.map(
      (entry) => loadParallaxLayer(
        ParallaxImageData(entry.key),
        fill: LayerFill.width,
        repeat: ImageRepeat.repeatY,
        velocityMultiplier: Vector2(0, entry.value),
      ),
    );

    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(0, -10),
      ),
    );
    add(parallax);
  }
}
