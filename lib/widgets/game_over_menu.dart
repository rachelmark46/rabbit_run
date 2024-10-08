import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/rabbit_run.dart';
import '/widgets/main_menu.dart';
import '/models/player_data.dart';
import '/game/audio_manager.dart';
import 'hud.dart';

// This represents the game over overlay,
// displayed with rabbit runs out of lives.
class GameOverMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'GameOverMenu';

  // Reference to parent game.
  final RabbitRun gameRef;

  const GameOverMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    const Text(
                      'Game Over',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Selector<PlayerData, int>(
                      selector: (_, playerData) => playerData.currentscore,
                      builder: (_, score, __) {
                        return Text(
                          'You Score: $score',
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Restart',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      onPressed: () {
                        gameRef.overlays.remove(GameOverMenu.id);
                        gameRef.overlays.add(Hud.id);
                        gameRef.reset();
                        gameRef.startGamePlay();
                        gameRef.resumeEngine();
                        AudioManager.instance.pauseBgm();
                        AudioManager.instance.startBgm('stage1.wav');

                        AudioManager.instance.resumeBgm();
                      },
                    ),
                    //   onPressed: () {
                    //     gameRef.overlays.remove(GameOverMenu.id);
                    //     gameRef.overlays.add(Hud.id);
                    //     gameRef.reset();
                    //     gameRef.startGamePlay();
                    //     gameRef.resumeEngine();
                    //     //gameRef.reset();
                    //     AudioManager.instance.resumeBgm();
                    //   },
                    // ),
                    ElevatedButton(
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      onPressed: () {
                        gameRef.overlays.remove(GameOverMenu.id);
                        gameRef.overlays.add(MainMenu.id);
                        //gameRef.resumeEngine();
                        gameRef.reset();
                        // gameRef.startGamePlay();
                        gameRef.resumeEngine();
                        AudioManager.instance.pauseBgm();
                        AudioManager.instance.startBgm('stage1.wav');

                        AudioManager.instance.resumeBgm();
                       // AudioManager.instance.resumeBgm();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
