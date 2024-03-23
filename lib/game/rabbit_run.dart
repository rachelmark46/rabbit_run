import 'package:dino_run/game/rabbit.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '/widgets/hud.dart';
import '/models/settings.dart';
import '/game/audio_manager.dart';
import '/game/enemy_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';

// This is the main flame game class.
class RabbitRun extends FlameGame with TapDetector, HasCollisionDetection {
  // List of all the image assets.
  static const _imageAssets = [

    'rabbit.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
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

  late Rabbit _rabbit;
  late Settings settings;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  // Track the current stage of the game.
  int currentStage = 1;
  late ParallaxComponent _parallaxBackgroundStage1;
  late ParallaxComponent _parallaxBackgroundStage2;

  //get _currentStage=> null;



 //get _currentStage => null;




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
    _parallaxBackgroundStage1 = await  _createParallaxBackground(
    //_createParallaxBackground([
      [ 'parallax/plx-1.png' ,
       'parallax/plx-2.png',
       'parallax/plx-3.png',
       'parallax/plx-4.png',
       'parallax/plx-5.png',
       'parallax/plx-6.png']

    //     baseVelocity: Vector2(10, 0),
    // velocityMultiplierDelta: Vector2(1.4, 0),

    );
    _parallaxBackgroundStage2 = await _createParallaxBackground(

        [ 'parallaxl/plx-1.png' ,
          'parallaxl/plx-2.png',
          'parallaxl/plx-3.png',
          'parallaxl/plx-4.png',
          'parallaxl/plx-5.png',
          'parallaxl/plx-6.png']

        // ParallaxImageData('parallaxl/plx-1.png'),
      // ParallaxImageData('parallaxl/plx-2.png'),
      // ParallaxImageData('parallaxl/plx-3.png'),
      // ParallaxImageData('parallaxl/plx-4.png'),
      // ParallaxImageData('parallaxl/plx-5.png'),
      // ParallaxImageData('parallaxl/plx-6.png'),// Add images for stage 2 background
      // Add more images for stage 2 background if needed

    //   baseVelocity: Vector2(10, 0),
    //   velocityMultiplierDelta: Vector2(1.4, 0),

    );

    // Add stage 1 background to the game by default
    add(_parallaxBackgroundStage1);
    /// Create a [ParallaxComponent] and add it to game.
    // final parallaxBackground = await loadParallaxComponent(
    //   [
    //     ParallaxImageData('parallax/plx-1.png'),
    //     ParallaxImageData('parallax/plx-2.png'),
    //     ParallaxImageData('parallax/plx-3.png'),
    //     ParallaxImageData('parallax/plx-4.png'),
    //     ParallaxImageData('parallax/plx-5.png'),
    //     ParallaxImageData('parallax/plx-6.png'),
    //   ],
    //   baseVelocity: Vector2(10, 0),
    //   velocityMultiplierDelta: Vector2(1.4, 0),
    // );
    // add(parallaxBackground);

    // Start the game with the initial setup.
    startGamePlay();

    return super.onLoad();
  }

  // This method creates a parallax background with provided image paths.
  Future<ParallaxComponent> _createParallaxBackground(List<String> imagePaths) async {
    return await loadParallaxComponent(
      imagePaths.map((path) => ParallaxImageData(path)).toList(),
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
  }

  /// This method add the already created [Dino]
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
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    // Check if the current score exceeds 100 and progress to stage 2
    if (currentStage == 1 && playerData.currentScore > 100) {
      progressToStage2();
    }
    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      // Trigger game over logic
      handleGameOver();
      // overlays.add(GameOverMenu.id);
      // overlays.remove(Hud.id);
      // pauseEngine();
      // AudioManager.instance.pauseBgm();
    }
    super.update(dt);
  }


  // Progress to stage 2
  void progressToStage2() {
    // Update the current stage to 2
   // _currentStage = 2;

    // Logic to transition to stage 2
    // For example:
    // Stop spawning enemies from stage 1 and start spawning stage 2 enemies
    _enemyManager.removeAllEnemies(); // Remove existing enemies
   // _enemyManager.spawnStage2Enemies(); // Spawn stage 2 enemies
    _enemyManager.setCurrentStage(2); // Update the current stage for the enemy manager
    _enemyManager.spawnRandomEnemy(); // Spawn stage 2 enemies

    // Additional transition logic here...
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
    // Make dino jump only when game is playing.
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
