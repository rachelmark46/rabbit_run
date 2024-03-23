import 'dart:math';
import 'package:dino_run/game/rabbit_run.dart';
import 'package:flame/components.dart';
import '../models/enemy_data.dart';
import 'enemy.dart';

class EnemyManager extends Component with HasGameRef<RabbitRun> {
  final List<EnemyData> _stage1Enemies = [];
  final List<EnemyData> _stage2Enemies = [];
  final Random _random = Random();
  final Timer _timer = Timer(2, repeat: true);

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    //var _currentStage;
    final List<EnemyData> currentStageEnemies =
    gameRef.currentStage == 1 ? _stage1Enemies : _stage2Enemies;

    final randomIndex = _random.nextInt(currentStageEnemies.length);
    final enemyData = currentStageEnemies[randomIndex];
    final enemy = Enemy(enemyData);

    // Set enemy properties, position, etc.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }
    enemy.size = enemyData.textureSize;

    gameRef.add(enemy);
  }

  void initEnemiesForStages() {
    // Don't fill list again and again on every mount.
 // if (_stage1Enemies.isEmpty) {
    // Initialize enemies for stage 1
    _stage1Enemies.addAll([
      EnemyData(
        image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
        nFrames: 16,
        stepTime: 0.1,
        textureSize: Vector2(36, 30),
        speedX: 80,
        canFly: false,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
        speedX: 100,
        canFly: true,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Rino/Run (52x34).png'),
        nFrames: 6,
        stepTime: 0.09,
        textureSize: Vector2(52, 34),
        speedX: 150,
        canFly: false,
      ),
      // Add more enemies for stage 1 as needed
    ]);
 // }

    // Don't fill list again and again on every mount.
//   //   if (_stage1Enemies.isEmpty) {
//   //
//   //     // Initialize enemy data for each stage
//   //     _stage1Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
//   //         nFrames: 16,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(36, 30),
//   //         speedX: 80,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage1Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
//   //         nFrames: 7,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(46, 30),
//   //         speedX: 100,
//   //         canFly: true,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage1Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Rino/Run (52x34).png'),
//   //         nFrames: 6,
//   //         stepTime: 0.09,
//   //         textureSize: Vector2(52, 34),
//   //         speedX: 150,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//   //     // Add more stages and enemies as needed
//   //
//   //     // Initialize enemy data for each stage
//   //     _stage2Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
//   //         nFrames: 16,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(36, 30),
//   //         speedX: 80,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage2Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
//   //         nFrames: 7,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(46, 30),
//   //         speedX: 100,
//   //         canFly: true,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage2Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Rino/Run (52x34).png'),
//   //         nFrames: 6,
//   //         stepTime: 0.09,
//   //         textureSize: Vector2(52, 34),
//   //         speedX: 150,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//       //   EnemyData(
//       //     image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
//       //     nFrames: 7,
//       //     stepTime: 0.1,
//       //     textureSize: Vector2(46, 30),
//       //     speedX: 100,
//       //     canFly: true,
//       //   ),
//       //   EnemyData(
//       //     image: gameRef.images.fromCache('Rino/Run (52x34).png'),
//       //     nFrames: 6,
//       //     stepTime: 0.09,
//       //     textureSize: Vector2(52, 34),
//       //     speedX: 150,
//       //     canFly: false,
//       //   ),
//       // ]);
//   //   }
//   //   _timer.start();
//   //   super.onMount();
//   // }

    // Initialize enemies for stage 2
    _stage2Enemies.addAll([
      EnemyData(
        image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
        speedX: 100,
        canFly: true,
      ),
      // Add more enemies for stage 2 as needed
    ]);
  }

 @override
  void onMount() {
    initEnemiesForStages();
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
    // Additional stage-specific logic for stage 2
    if (gameRef.currentStage == 2) {
      // Adjust enemy spawning frequency, speed, etc. for stage 2
      // For example:
      // _timer.updateInterval(1); // Faster enemy spawning for stage 2
    }
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }

//Method to set the current stage
  void setCurrentStage(int stage) {
    var _currentStage = stage;
  }

}

// import 'dart:math';
// import 'package:dino_run/game/rabbit_run.dart';
// import 'package:flame/components.dart';
// import '/game/enemy.dart';
//
// import '/models/enemy_data.dart';
//
// // This class is responsible for spawning random enemies at certain
// // interval of time depending upon players current score.
// class EnemyManager extends Component with HasGameRef<RabbitRun> {
//   // A list to hold data for all the enemies.
//   // Lists to hold enemies for each stage
//   final List<EnemyData> _stage1Enemies = [];
//   final List<EnemyData> _stage2Enemies = [];
//
//
//   // Random generator required for randomly selecting enemy type.
//   final Random _random = Random();
//
//   // Timer to decide when to spawn next enemy.
//   final Timer _timer = Timer(2, repeat: true);
//   //int _currentStage = 1; // Current stage
//
//
//
//   EnemyManager() {
//     _timer.onTick = spawnRandomEnemy;
//   }
//
//   // This method is responsible for spawning a random enemy.
//   void spawnRandomEnemy() {
//     final List<EnemyData> currentStageEnemies =
//     gameRef.currentStage == 1 ? _stage1Enemies : _stage2Enemies;
//
//
//     // final enemyDataList = _stage1Enemies[ ]; // Get enemy data for current stage
//
//     // Generate a random index within the current stage's enemy list
//     final randomIndex = _random.nextInt(currentStageEnemies.length);
//     final enemyData = currentStageEnemies[randomIndex];
//     // /// Generate a random index within [_data] and get an [EnemyData].
//     // final randomIndex = _random.nextInt(_data.length);
//     // final enemyData = _data.elementAt(randomIndex);
//     final enemy = Enemy(enemyData);
//
//     // Help in setting all enemies on ground.
//     enemy.anchor = Anchor.bottomLeft;
//     enemy.position = Vector2(
//       gameRef.size.x + 32,
//       gameRef.size.y - 24,
//     );
//
//     // If this enemy can fly, set its y position randomly.
//     if (enemyData.canFly) {
//       final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
//       enemy.position.y -= newHeight;
//     }
//
//     // Due to the size of our viewport, we can
//     // use textureSize as size for the components.
//     enemy.size = enemyData.textureSize;
//     gameRef.add(enemy);
//   }
//
//   // Method to initialize enemies for each stage
//   void initEnemiesForStages() {
//     // Populate _stage1Enemies and _stage2Enemies with appropriate enemy data
//     // ...
//   }
//
//   @override
//
//   void onMount() {
//     // Initialize enemies for each stage
//     initEnemiesForStages();
//     // Start the timer for spawning enemies
//     _timer.start();
//     super.onMount();
//   }
//   // void onMount() {
//   //   if (isMounted) {
//   //     removeFromParent();
//   //   }
//   //
//   //   // Don't fill list again and again on every mount.
//   //   if (_stage1Enemies.isEmpty) {
//   //
//   //     // Initialize enemy data for each stage
//   //     _stage1Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
//   //         nFrames: 16,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(36, 30),
//   //         speedX: 80,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage1Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
//   //         nFrames: 7,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(46, 30),
//   //         speedX: 100,
//   //         canFly: true,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage1Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Rino/Run (52x34).png'),
//   //         nFrames: 6,
//   //         stepTime: 0.09,
//   //         textureSize: Vector2(52, 34),
//   //         speedX: 150,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//   //     // Add more stages and enemies as needed
//   //
//   //     // Initialize enemy data for each stage
//   //     _stage2Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
//   //         nFrames: 16,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(36, 30),
//   //         speedX: 80,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage2Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
//   //         nFrames: 7,
//   //         stepTime: 0.1,
//   //         textureSize: Vector2(46, 30),
//   //         speedX: 100,
//   //         canFly: true,
//   //       ),
//   //     ] as EnemyData);
//   //     _stage2Enemies.add([
//   //       EnemyData(
//   //         image: gameRef.images.fromCache('Rino/Run (52x34).png'),
//   //         nFrames: 6,
//   //         stepTime: 0.09,
//   //         textureSize: Vector2(52, 34),
//   //         speedX: 150,
//   //         canFly: false,
//   //       ),
//   //     ] as EnemyData);
//       //   EnemyData(
//       //     image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
//       //     nFrames: 7,
//       //     stepTime: 0.1,
//       //     textureSize: Vector2(46, 30),
//       //     speedX: 100,
//       //     canFly: true,
//       //   ),
//       //   EnemyData(
//       //     image: gameRef.images.fromCache('Rino/Run (52x34).png'),
//       //     nFrames: 6,
//       //     stepTime: 0.09,
//       //     textureSize: Vector2(52, 34),
//       //     speedX: 150,
//       //     canFly: false,
//       //   ),
//       // ]);
//   //   }
//   //   _timer.start();
//   //   super.onMount();
//   // }
//
//
//   void update(double dt) {
//     _timer.update(dt);
//     super.update(dt);
//     // Additional stage-specific logic for stage 2
//     if (gameRef._currentStage == 2) {
//       // For example, adjust enemy spawning frequency, speed, etc.
//       // ...
//     }
//   }
//
//
//   void removeAllEnemies() {
//     final enemies = gameRef.children.whereType<Enemy>();
//     for (var enemy in enemies) {
//       enemy.removeFromParent();
//     }
//   }
//
//   // Method to set the current stage
//   void setCurrentStage(int stage) {
//     _currentStage = stage;
//   }
//
// }
