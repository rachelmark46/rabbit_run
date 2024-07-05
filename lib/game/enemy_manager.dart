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
  // Store the score separately
  int score = 0;

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    print("under spawn random enemy");
    // gameRef.currentStage == _enemyManager.gameRef.currentStage ;
    print(gameRef.currentlevel);
    final List<EnemyData> currentStageEnemies =
        gameRef.currentlevel == 1 ? _stage1Enemies : _stage2Enemies;

    final randomIndex = _random.nextInt(currentStageEnemies.length);
    final enemyData = currentStageEnemies[randomIndex];
    final enemy = Enemy(enemyData);

    // Set enemy properties, position, etc.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 55,
    );
    if (enemyData.canFly) {

      final newHeight = _random.nextDouble() * 2 *( enemyData.textureSize.y)*2;
      enemy.position.y -= newHeight;
    }
    enemy.size = (enemyData.textureSize)* 2;

    gameRef.add(enemy);
  }

// Method to spawn stage 1 enemies
  void spawnStage1Enemies() {
    _spawnEnemies(_stage1Enemies);
  }

  // Method to spawn stage 2 enemies
  void spawnStage2Enemies() {
    _spawnEnemies(_stage2Enemies);
  }

  void _spawnEnemies(List<EnemyData> enemyList) {
    for (var enemyData in enemyList) {
      final enemy = Enemy(enemyData);

      // Set enemy properties, position, etc.
      enemy.anchor = Anchor.bottomLeft;
      enemy.position = Vector2(
        gameRef.size.x + 32,
        gameRef.size.y - 55,
      );
      if (enemyData.canFly) {
        final newHeight = _random.nextDouble() * 2 * (enemyData.textureSize.y)*2;
        enemy.position.y -= newHeight;
      }
      enemy.size = enemyData.textureSize;

      gameRef.add(enemy);
    }
  }

  void initEnemiesForStages() {
    // Don't fill list again and again on every mount.
    // if  (_stage1Enemies.isEmpty) {
    // Initialize enemies for stage 1
    _stage1Enemies.addAll([
      EnemyData(
        image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
        nFrames: 16,
        stepTime: 0.1,
        textureSize: Vector2(36, 30),
        speedX: 130, //earlier 80
        canFly: false,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
        speedX: 150, //earlier 100
        canFly: true,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Rino/Run (52x34).png'),
        nFrames: 6,
        stepTime: 0.09,
        textureSize: Vector2(52, 34),
        speedX: 200,
        canFly: false,
      ),
      // Add more enemies for stage 1 as needed
    ]);

    // Don't fill list again and again on every mount.
    //else  if (_stage2Enemies.isEmpty) {
    // Initialize enemy data for each stage
    _stage2Enemies.addAll([
      EnemyData(
        image: gameRef.images.fromCache('Bee/Attack (36x34).png'),
        nFrames: 8,
        stepTime: 0.1,
        textureSize: Vector2(36, 34),
        speedX: 140,   // 80
        canFly: true,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Rocks/Rock1_Run (38x34).png'),
        nFrames: 14,
        stepTime: 0.1,
        textureSize: Vector2(38, 34),
        speedX: 180, //150
        canFly: false,
      ),
      // EnemyData(
      //   image: gameRef.images.fromCache('Chameleon/Run (84x38).png'),
      //   nFrames: 8,
      //   stepTime: 0.1,
      //   textureSize: Vector2(84, 38),
      //   speedX: 80,
      //   canFly: false,
      // ),
      EnemyData(
        image: gameRef.images.fromCache('BlueBird/Flying (32x32).png'),
        nFrames: 9,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
        speedX: 175, //100
        canFly: true,
      ),
    ]);
    //}
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
    // if (gameRef.currentStage == 2) {
    // // Adjust enemy spawning frequency, speed, etc. for stage 2
    // // For example:
    // _timer.updateInterval(1); // Faster enemy spawning for stage 2
    //  }
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    _stage1Enemies.clear();
    _stage2Enemies.clear();

    for (var enemy in enemies) {


      enemy.removeFromParent();
    }
  }

  // Method to set the current stage
  void setCurrentStage(int stage) {
    gameRef.currentlevel = stage;
  }
}
