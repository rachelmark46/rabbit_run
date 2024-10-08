import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'game/rabbit_run.dart';
import 'widgets/hud.dart';
import 'models/settings.dart';
import 'widgets/main_menu.dart';
import 'models/player_data.dart';
import 'widgets/pause_menu.dart';
import 'widgets/settings_menu.dart';
import 'widgets/game_over_menu.dart';
import 'widgets/celeb_widget.dart';
import 'splash_screen_page.dart';

/// This is the single instance of [RabbitRun] which
/// will be reused throughout the lifecycle of the game.
RabbitRun _rabbitRun = RabbitRun();

Future<void> main() async {
  // Ensures that all bindings are initialized
  // before was start calling hive and flame code
  // dealing with platform channels.
  WidgetsFlutterBinding.ensureInitialized();
  // Makes the game full screen and landscape only.
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  // Initializes hive and register the adapters.
  await initHive();
  runApp(const MyApp());
}

// This function will initilize hive with apps documents directory.
// Additionally it will also register all the hive adapters.
Future<void> initHive() async {
  // For web hive does not need to be initialized.
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }
  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
  Hive.registerAdapter<Settings>(SettingsAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String versionNumber = '1.0.0';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RABBIT RUN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const SplashScreenPage(),
    );
  }
}

// The main widget for this game.
class RabbitRunApp extends StatelessWidget {
  const RabbitRunApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rabbit Run ',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Settings up some default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget(
          // This will dislpay a loading bar until [RabbitRun] completes
          // its onLoad method.
          loadingBuilder: (context) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          // Register all the overlays that will be used by this game.
          overlayBuilderMap: {
            MainMenu.id: (_, RabbitRun gameRef) => MainMenu(gameRef),
            PauseMenu.id: (_, RabbitRun gameRef) => PauseMenu(gameRef),
            Hud.id: (_, RabbitRun gameRef) => Hud(gameRef),
            GameOverMenu.id: (_, RabbitRun gameRef) => GameOverMenu(gameRef),
            SettingsMenu.id: (_, RabbitRun gameRef) => SettingsMenu(gameRef),
            CelebWidget.id: (_, RabbitRun gameRef) => CelebWidget(gameRef),
          },
          // By default MainMenu overlay will be active.
          initialActiveOverlays: const [MainMenu.id],
          game: _rabbitRun,
        ),
      ),
    );
  }
}
