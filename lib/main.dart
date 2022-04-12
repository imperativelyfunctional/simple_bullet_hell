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
              duration: 1, infinite: false, curve: Curves.bounceIn)),
      MoveEffect.to(
          Vector2(size.x / 2.0, 300),
          EffectController(
              duration: 1, infinite: false, curve: Curves.easeInExpo))
    ], infinite: false));

    var counter = 10;
    async.Timer.periodic(const Duration(seconds: 5), (timer) {
      double speed = 100;
      async.Timer.periodic(const Duration(milliseconds: 300), (timer) {
        if (timer.tick == counter) {
          counter++;
          timer.cancel();
        }
        for (int i = 0; i < 37; i++) {
          var bullet = Bullet1(boss, (pi / 37 - pi) * i, speed: speed)
            ..position = boss.position
            ..scale = boss.scale;
          add(bullet);
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
