import 'dart:io';
import 'package:dino_run/game/rabbit.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../models/level_manager.dart';
import '/widgets/hud.dart';
import '/models/settings.dart';
import '/game/audio_manager.dart';
import '/game/enemy_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';
import 'dart:async';
import '/widgets/celeb_widget.dart';

// This is the main flame game class.
class RabbitRun extends FlameGame with TapDetector, HasCollisionDetection {
  // List of all the image assets.
  static const _imageAssets = [
    'rabbit.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Bee/Attack (36x34).png',
    'BlueBird/Flying (32x32).png',
    'Chameleon/Run (84x38).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
    'parallaxl/plx-1.png',
    'parallaxl/plx-2.png',
    'parallaxl/plx-3.png',
    'parallaxl/plx-4.png',
    'parallaxl/plx-5.png',
    'parallaxl/plx-6.png',
  ];

  // List of all the audio assets.
  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  late LevelManager _levelManager;
  late Rabbit _rabbit;
  late Settings settings;
  late PlayerData playerData;
  late EnemyManager _enemyManager;
  bool isPlaying = false;

  // Track the current stage of the game.
  int currentStage = 1;
  int currentscore = 0;
  late ParallaxComponent _parallaxBackgroundStage1;
  late ParallaxComponent _parallaxBackgroundStage2;

  // This method get called while flame is preparing this game.
  @override
  Future<void> onLoad() async {
    /// Read [PlayerData] and [Settings] from hive.
    playerData = await _readPlayerData();
    settings = await _readSettings();

    /// Initilize [AudioManager].
    await AudioManager.instance.init(_audioAssets, settings);

    // Start playing background music. Internally takes care
    // of checking user settings.
    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');

    // Cache all the images.
    await images.loadAll(_imageAssets);

    // Set a fixed viewport to avoid manually scaling
    // and handling different screen sizes.
    camera.viewport = FixedResolutionViewport(Vector2(360, 180));

    /// Create parallax backgrounds for both stages.
    _parallaxBackgroundStage1 = await _createParallaxBackground(
        //_createParallaxBackground([
        [
          'parallax/plx-1.png',
          'parallax/plx-2.png',
          'parallax/plx-3.png',
          'parallax/plx-4.png',
          'parallax/plx-5.png',
          'parallax/plx-6.png'
        ]);
    _parallaxBackgroundStage2 = await _createParallaxBackground([
      'parallaxl/plx-1.png',
      'parallaxl/plx-2.png',
      'parallaxl/plx-3.png',
      'parallaxl/plx-4.png',
      'parallaxl/plx-5.png',
      'parallaxl/plx-6.png'
    ]);

    // Add stage 1 background to the game by default
    add(_parallaxBackgroundStage1);

    // Instantiate the level manager and set the initial level
    _levelManager = LevelManager(selectedLevel: 1);

    return super.onLoad();
  }

  // This method creates a parallax background with provided image paths.
  Future<ParallaxComponent> _createParallaxBackground(
      List<String> imagePaths) async {
    return await loadParallaxComponent(
      imagePaths.map((path) => ParallaxImageData(path)).toList(),
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
  }

  /// This method add the already created [Rabbit]
  /// and [EnemyManager] to this game.
  void startGamePlay() {
    // Create a new instance of Rabbit and EnemyManager
    _rabbit = Rabbit(images.fromCache('rabbit.png'), playerData);
    _enemyManager = EnemyManager();

// Add Rabbit and EnemyManager to the game
    add(_rabbit);
    add(_enemyManager);
  }

  // This method remove all the actors from the game.
  void _disconnectActors() {
    _rabbit.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.

    _disconnectActors();

    // Reset player data to inital values.
    playerData.currentScore = 0;
    playerData.lives = 500;
    playerData.currentStage = 1;
  }

  //Method to update the score
  void updateScore(int bonus) {
    playerData.currentScore = playerData.currentScore + bonus;
  }

  // Method to start the confetti animation and stop after 15 seconds
  void _startConfetti() {
    // Return if confetti is already playing
    if (!isPlaying) {
      // Initialize the ConfettiController if not already initialized
      // _controller =
      //     ConfettiController(duration: const Duration(seconds: 15));

      // Play the confetti animation
      //controller.play();
      print(" Confetti Confetti ");
      // Stop the confetti after 15 seconds
      // Future.delayed(const Duration(seconds: 15), () {
      // isPlaying = true;
      sleep(Duration(seconds: 5));
      print("stop  stop ");
      // _controller.stop();
      isPlaying = true;
      //  });
    }
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    super.update(dt);

    // Check if the current score meets the criteria to progress to the next level
    if (_levelManager.shouldLevelUp(playerData.currentScore)) {
      // Progress to the next level

      _levelManager.increaseLevel();

      // Update game environment based on the current level
      updateGameEnvironment();
    }

    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      // Trigger game over logic
      handleGameOver();
    }
  }

  // Method to update the game environment based on the current level
  void updateGameEnvironment() {
    // Implement logic to update game environment (background, enemies, etc.)
    // based on the current level
    _enemyManager.setCurrentStage(_levelManager.level);

    int currentLevel = _levelManager.level;

    // Example: Update background and enemies based on the current level
    if (currentLevel == 2) {
      // Update background to stage 2 background

      pauseEngine();
      overlays.add(CelebWidget.id);

      AudioManager.instance.pauseBgm();

      print("PAUSED");

      print(" Conffeti Playing ");

      updateScore(50);
      print("updated score ");
      print(playerData.currentScore);
      // Stop the confetti after 15 seconds
      // Future.delayed(const Duration(seconds: 15), () {
      //   // isPlaying = true;
      //   // sleep(Duration(seconds: 5));
      //   print("stop  stop ");
      //   // _controller.stop();
      // //  isPlaying = true;
      // });

      remove(_parallaxBackgroundStage1);

      add(_parallaxBackgroundStage2);
      _rabbit = Rabbit(images.fromCache('rabbit.png'), playerData);
      add(_rabbit);

      //  // Update enemy difficulty or spawn different enemies for level 2
      //  // _enemyManager.updateEnemyDifficultyForLevel(2);

      resumeEngine();
      print("RESUMED");
      // Ensure the Rabbit is added if it's not already in the game
      if (_rabbit == null) {
        print("rabbit is null");
        _rabbit = Rabbit(images.fromCache('rabbit.png'), playerData);
        add(_rabbit);
      }

      // Update enemy difficulty or spawn different enemies for level 2

      _enemyManager.removeAllEnemies();

      _enemyManager.spawnStage2Enemies();

      // Additional logic for other levels...
    }
  }

  // Game over logic
  void handleGameOver() {
    // Add game over menu, pause engine, etc.
    // Your existing game over logic here...
    overlays.add(GameOverMenu.id);
    overlays.remove(Hud.id);
    pauseEngine();
    AudioManager.instance.pauseBgm();
  }

  // This will get called for each tap on the screen.
  @override
  void onTapDown(TapDownInfo info) {
    // Make rabbit jump only when game is playing.
    // When game is in playing state, only Hud will be the active overlay.
    if (overlays.isActive(Hud.id)) {
      _rabbit.jump();
      // isOnGround = true ;
    }
    super.onTapDown(info);
  }

  /// This method reads [PlayerData] from the hive box.
  Future<PlayerData> _readPlayerData() async {
    final playerDataBox =
        await Hive.openBox<PlayerData>('RabbitRun.PlayerDataBox');
    final playerData = playerDataBox.get('RabbitRun.PlayerData');

    // If data is null, this is probably a fresh launch of the game.
    if (playerData == null) {
      // In such cases store default values in hive.
      await playerDataBox.put('RabbitRun.PlayerData', PlayerData());
    }

    // Now it is safe to return the stored value.
    return playerDataBox.get('RabbitRun.PlayerData')!;
  }

  /// This method reads [Settings] from the hive box.
  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('RabbitRun.SettingsBox');
    final settings = settingsBox.get('RabbitRun.Settings');

    // If data is null, this is probably a fresh launch of the game.
    if (settings == null) {
      // In such cases store default values in hive.
      await settingsBox.put(
        'RabbitRun.Settings',
        Settings(bgm: true, sfx: true),
      );
    }

    // Now it is safe to return the stored value.
    return settingsBox.get('RabbitRun.Settings')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // On resume, if active overlay is not PauseMenu,
        // resume the engine (lets the parallax effect play).
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        // If game is active, then remove Hud and add PauseMenu
        // before pausing the game.
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
