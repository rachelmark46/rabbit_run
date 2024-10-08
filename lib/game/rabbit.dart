import 'dart:ui';
import '/game/rabbit_run.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

/// This enum represents the animation states of [Rabbit].
enum RabbitAnimationStates {
  idle,
  run,
  kick,
  hit,
  sprint,
  pop,
}

// This represents the rabbit character of this game.
class Rabbit extends SpriteAnimationGroupComponent<RabbitAnimationStates>
    with CollisionCallbacks, HasGameRef<RabbitRun> {
  // A map of all the animation states and their corresponding animations.
  static final _animationMap = {
    RabbitAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
    ),
    RabbitAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((5) * 24, 0),
    ),
    RabbitAnimationStates.kick: SpriteAnimationData.sequenced(
      // amount: 3,
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((5 + 9) * 24, 0),
    ),
    RabbitAnimationStates.sprint: SpriteAnimationData.sequenced(
      amount: 5,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((1 + 4 + 4) * 24, 0),
    ),
    RabbitAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((1 + 4 + 4 + 5) * 24, 0),
    ),
    RabbitAnimationStates.pop: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((1 + 4 + 4 + 5 + 3) * 24, 0),
    ),
  };

  // The max distance from top of the screen beyond which
  // rabbit should never go. Basically the screen height - ground height
  double yMax = 0.0;

  // Rabbit's current speed along y-axis.
  double speedY = 0.0;

  // Controlls how long the hit animations will be played.
  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  final PlayerData playerData;

  bool isHit = false;
  //Returns true if dino is on ground.

  Rabbit(Image image, this.playerData)
      : super.fromFrameData(image, _animationMap);

  @override
  void onMount() {
    // First reset all the important properties, because onMount()
    // will be called even while restarting the game.
    reset();

    // Add a hitbox for rabbit.
    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.5, size.y * 0.3) / 2,
        //position: Vector2(size.x * 0.5, size.y * 0.7) / 2,
      ),
    );
    yMax = y;

    /// Set the callback for [_hitTimer].
    _hitTimer.onTick = () {
      current = RabbitAnimationStates.run;
      isHit = false;
    };

    super.onMount();
  }

  @override
  void update(double dt) {
    // v = u + at
    speedY +=  gravity * dt;

    // d = s0 + s * t
    y +=  speedY * dt;

    /// This code makes sure that rabbit never goes beyond [yMax].
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if ((current != RabbitAnimationStates.hit) &&
          (current != RabbitAnimationStates.run)) {
        current = RabbitAnimationStates.run;
      }
    }

    _hitTimer.update(dt);
    super.update(dt);
  }

  // Gets called when rabbit collides with other Collidables.
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Call hit only if other component is an Enemy and dino
    // is not already in hit state.
    if ((other is Enemy) && (!isHit)) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

// Returns true if dino is on ground.
  bool get isOnGround => (y >= yMax);

  // Makes the rabbit jump.
  void jump() {
    // Jump only if rabbit is on ground.
    if (isOnGround) {
      speedY = -520; // earlier -500
      current = RabbitAnimationStates.idle;
      AudioManager.instance.playSfx('jump.wav');
    }
  }

  // This method changes the animation state to
  // , plays the hit sound
  // effect and reduces the player life by 1.
  void hit() {
    isHit = true;
    AudioManager.instance.playSfx('hurt.wav');
    current = RabbitAnimationStates.hit;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  // This method reset some of the important properties
  // of this component back to normal.
  void reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    //position = Vector2(32, gameRef.size.y - 25);
    position = Vector2(32, gameRef.size.y - 55);
    size = Vector2.all(50);
    current = RabbitAnimationStates.run;
    isHit = false;
    speedY = 0.0;

  }
}
