import 'dart:ui';
import 'package:dino_run/game/rabbit_run.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

/// This enum represents the animation states of [Dino].
enum RabbitAnimationStates {
  idle,
  run,
  kick,
  hit,
  sprint, pop,
}

// This represents the dino character of this game.
class Rabbit extends SpriteAnimationGroupComponent<RabbitAnimationStates>
    with CollisionCallbacks, HasGameRef<RabbitRun> {
  // A map of all the animation states and their corresponding animations.
  static final _animationMap = {
    RabbitAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 1,
      //amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
    ),
    RabbitAnimationStates.sprint: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((1 ) * 24, 0),
    ),
    RabbitAnimationStates.run: SpriteAnimationData.sequenced(
     // amount: 3,
      amount:4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((1+4) * 24, 0),
    ),
    RabbitAnimationStates.pop: SpriteAnimationData.sequenced(
      amount: 5,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2(( 1 + 4+4) * 24, 0),
    ),

    RabbitAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2(( 1 + 4+4+5) * 24, 0),
    ),

    RabbitAnimationStates.kick: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((1+4+4+5+3) * 24, 0),
    ),
  };

  // The max distance from top of the screen beyond which
  // dino should never go. Basically the screen height - ground height
  double yMax = 0.0;
  //  double yMax = 0.0;

  // Dino's current speed along y-axis.
  double speedY = 0.0;
  bool isJumping = false;

  // Controlls how long the hit animations will be played.
  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  final PlayerData playerData;

  bool isHit = false;
  //Returns true if dino is on ground.
  //bool get isOnGround => (y >= yMax);
 bool isOnGround = true ;
  Rabbit(Image image, this.playerData)
      : super.fromFrameData(image, _animationMap);

 @override
  void onMount() {
    // First reset all the important properties, because onMount()
    // will be called even while restarting the game.
    _reset();

    // Add a hitbox for dino.
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
    speedY += gravity * dt;

    // d = s0 + s * t
    y += speedY * dt;

    /// This code makes sure that dino never goes beyond [yMax].
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if ((current != RabbitAnimationStates.hit) &&
          (current != RabbitAnimationStates.sprint )) {
        current = RabbitAnimationStates.run;
      }
    }

    _hitTimer.update(dt);
    super.update(dt);
  }

  // Gets called when dino collides with other Collidables.
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Call hit only if other component is an Enemy and dino
    // is not already in hit state.
    if ((other is Enemy) && (!isHit)) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }



  // void jump() {
  //   if (isOnGround) {
  //     if (!_isJumping) {
  //       _isJumping = true;
  //       //speedY = -300;
  //       current = RabbitAnimationStates.sprint;
  //       AudioManager.instance.playSfx('jump14.wav');
  //       // Logic to handle jumping movement
  //     }
  //   }
  // }


  void run() {
    if (isJumping) {
      isJumping = false;
      speedY = -300;
      current = RabbitAnimationStates.run;
      // Logic to handle running movement
    }
  }

 // Makes the dino jump.
  void jump() {
    // Jump only if dino is on ground.
    //if (isOnGround && !isJumping) {
    if (isOnGround){
      isJumping = true;
      isOnGround = false ;
      speedY = -300;
      current = RabbitAnimationStates.sprint;
      AudioManager.instance.playSfx('jump14.wav');
    }
    isOnGround = true ;
  }

  // This method changes the animation state to
  /// [DinoAnimationStates.hit], plays the hit sound
  /// effect and reduces the player life by 1.
  void hit() {
    isHit = true;
    AudioManager.instance.playSfx('hurt7.wav');
   current = RabbitAnimationStates.hit;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  // This method reset some of the important properties
  // of this component back to normal.
  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    //position = Vector2(32, gameRef.size.y - 22);
    position = Vector2(32, gameRef.size.y - 25);
    size = Vector2.all(24);
    current = RabbitAnimationStates.run;
    isHit = false;
    speedY = 0.0;
  }
}
