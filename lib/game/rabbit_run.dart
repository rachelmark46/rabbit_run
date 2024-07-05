import 'dart:math';

import 'package:dino_run/game/rabbit.dart';
import 'package:flame/camera.dart';
//import 'package:flame/camera.dart';
import 'package:flame/events.dart';
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
    'Rocks/Rock1_Run (38x34).png',
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
    // '8BitPlatformerLoop.wav',
    // 'hurt7.wav',
    // 'jump14.wav',
    'stage1.wav',
    'hurt.wav',
    'jump.wav',
    'stage2.wav',
    'complete_level.wav'
  ];

  late LevelManager _levelManager;
  late Rabbit _rabbit;
  late Settings settings;
  late PlayerData playerData;
  late EnemyManager _enemyManager;
  bool isPlaying = false;
  bool parallaxBackgroundAdded = false;

  // Track the current stage of the game.
  int currentlevel = 1;
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
   // AudioManager.instance.startBgm('8BitPlatformerLoop.wav');
    AudioManager.instance.startBgm('stage1.wav');

    // Cache all the images.
    await images.loadAll(_imageAssets);

    // Set a fixed viewport to avoid manually scaling
    // and handling different screen sizes.
  camera.viewport = MaxViewport();
   // double maxSide = min(size.x, size.y);
    //earlier
    //camera.viewport = FixedResolutionViewport(Vector2(360, 180));
  // camera.viewport =FixedResolutionViewport(resolution: Vector2(720,360) );
    //camera.viewport = FixedResolutionViewport(Vector2(size.x , size.y), resolution: Vector2(size.x,size.y));
    //working horizontally half screen
    //camera.viewport = FixedAspectRatioViewport(aspectRatio: 4);


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
    parallaxBackgroundAdded = true;

    // Instantiate the level manager and set the initial level
    _levelManager = LevelManager(level: currentlevel);

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
    // clear all old background rabbit and enemies

   // _disconnectActors();
    // Create a new instance of Rabbit and EnemyManager

    currentlevel = 1;
    print(playerData.currentlevel);
    // this will work only when there is no background added
    addParallaxBackground(_parallaxBackgroundStage1);
    _rabbit = Rabbit(images.fromCache('rabbit.png'), playerData);

    _rabbit.addToParent(_parallaxBackgroundStage1);
    _enemyManager = EnemyManager();
    add(_enemyManager);
    _levelManager = LevelManager(level: currentlevel);
// Add Rabbit and EnemyManager to the game
  }

  Future<void> addParallaxBackground(
      ParallaxComponent parallaxBackground) async {
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

    if (!parallaxBackgroundAdded) {
      add(parallaxBackground);
      parallaxBackgroundAdded = true;
    }
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
    print("under  reset ");
    print(playerData.currentlevel);
    if ((playerData.currentlevel == 1) && (parallaxBackgroundAdded = true)) {
      //remove(_parallaxBackgroundStage1 );
      _parallaxBackgroundStage1.removeFromParent();
      parallaxBackgroundAdded = false;

      _enemyManager.removeAllEnemies();
    } else if ((playerData.currentlevel == 2) &&
        (parallaxBackgroundAdded = true)) {
      //remove(_parallaxBackgroundStage2);
      _parallaxBackgroundStage2.removeFromParent();
      parallaxBackgroundAdded = false;
      _enemyManager.removeAllEnemies();
    }
    // Reset player data to inital values.
    playerData.currentscore = 0;
    playerData.lives = 5;
    playerData.currentlevel = 1;
    //_background();
    //add(_parallaxBackgroundStage1);
  }

  //Method to update the score
  void updateScore(int bonus) {
    playerData.currentscore = playerData.currentscore + bonus;
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    super.update(dt);

    // Check if the current score meets the criteria to progress to the next level
    if (_levelManager.shouldLevelUp(playerData.currentscore)) {
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
    if (playerData.currentscore >= 150) {
     // pauseEngine();
      AudioManager.instance.pauseBgm();
      // Future.delayed(const Duration(seconds: 2)){
      //CelebWidget.id;
     // overlays.add(CelebWidget.id); //not working
      pauseEngine();
      AudioManager.instance.playSfx('complete_level.wav');
      overlays.add(CelebWidget.id);
      // };

      //pauseEngine();
      //AudioManager.instance.pauseBgm();
      // pauseEngine();
      //Future.delayed(const Duration(seconds: 5));
      //overlays.add(CelebWidget.id);
      //Future.delayed(const Duration(seconds: 2));
      //pauseEngine();
      // AudioManager.instance.playSfx('complete_level.wav');
      // Future.delayed(const Duration(seconds: 2));

      // pauseEngine();
      Future.delayed(const Duration(seconds: 3), () {
        pauseEngine();
        //write the event you want it to happen after duration of seconds
          gameEnd();
      });
      // Future.delayed(const Duration(seconds: 2)){
      //   gameEnd();
      // };
    }
  }
  void updateBackground() {
    if ((_levelManager.level == 2) && (parallaxBackgroundAdded = true)) {
      _parallaxBackgroundStage1.removeFromParent();
      parallaxBackgroundAdded = false;
      _enemyManager.removeAllEnemies();
      addParallaxBackground(_parallaxBackgroundStage2);
    }
  }

  // Method to update the game environment based on the current level
  void updateGameEnvironment() {
    // Implement logic to update game environment (background, enemies, etc.)
    // based on the current level
    int currentlevel = _levelManager.level;
    // Example: Update background and enemies based on the current level
    if (currentlevel == 2) {
      // Update background to stage 2 background
      _enemyManager.setCurrentStage(currentlevel);
      pauseEngine();
      overlays.add(CelebWidget.id);
      AudioManager.instance.pauseBgm();
      updateScore(50);

      _rabbit.removeFromParent();
      _enemyManager.removeAllEnemies();
      updateBackground(); // working
      AudioManager.instance.startBgm('stage2.wav');

      _rabbit = Rabbit(images.fromCache('rabbit.png'), playerData);
      _rabbit.addToParent(_parallaxBackgroundStage2);

      resumeEngine();
      print("RESUMED");

      add(_enemyManager);
      _enemyManager.spawnStage2Enemies();
      // Additional logic for other
      // levels...
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
   // AudioManager.instance.startBgm('stage1.wav');
  }

  // game finished with player reaching end
  void gameEnd() {
    // Add game over menu, pause engine, etc.
    // Your existing game over logic here...
    //pauseEngine();
    // overlays.add(CelebWidget.id);
    //  AudioManager.instance.pauseBgm();
    // AudioManager.instance.playSfx('complete_level.wav');
    // pauseEngine();
   // overlays.add(CelebWidget.id);
    overlays.add(GameOverMenu.id);
    overlays.remove(Hud.id);
    AudioManager.instance.stopBgm();
    AudioManager.instance.startBgm('stage1.wav');
    AudioManager.instance.stopBgm();

    // AudioManager.instance.startBgm('stage1.wav');
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
