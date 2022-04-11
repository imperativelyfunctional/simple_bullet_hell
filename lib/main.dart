import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

import 'Bullet1.dart';

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

    await addBoss();
    await addParallaxBackground();
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
        priority: 20,
        animation: running,
        anchor: Anchor.center,
        size: imageSize,
        angle: pi,
        position: Vector2(size.x / 2.0, 300),
        scale: Vector2(0.5, 0.5));

    async.Timer.periodic(const Duration(milliseconds: 100), (timer) {
      var random = Random();
      var bullet = Bullet1(
          boss, (pi / 180) * random.nextInt(180) * (random.nextBool() ? 1 : -1))
        ..position = Vector2(boss.width / 2, boss.height / 2);
      boss.add(bullet);
    });
    async.Timer.periodic(const Duration(milliseconds: 100), (timer) {
      var random = Random();
      var bullet = Bullet1(
          boss, (pi / 180) * random.nextInt(180) * (random.nextBool() ? 1 : -1))
        ..position = Vector2(boss.width / 2, boss.height / 2);
      boss.add(bullet);
    });    async.Timer.periodic(const Duration(milliseconds: 100), (timer) {
      var random = Random();
      var bullet = Bullet1(
          boss, (pi / 180) * random.nextInt(180) * (random.nextBool() ? 1 : -1))
        ..position = Vector2(boss.width / 2, boss.height / 2);
      boss.add(bullet);
    });
    async.Timer.periodic(const Duration(milliseconds: 100), (timer) {
      var random = Random();
      var bullet = Bullet1(
          boss, (pi / 180) * random.nextInt(180) * (random.nextBool() ? 1 : -1))
        ..position = Vector2(boss.width / 2, boss.height / 2);
      boss.add(bullet);
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
