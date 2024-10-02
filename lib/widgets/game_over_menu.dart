import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_donation_buttons/donationButtons/buyMeACoffeeButton.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                          fontSize: 15,
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
                          fontSize: 15,
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

                    //add support us and check other apps and about us here

                    // buy me a coffee button
                    BuyMeACoffeeButton(
                      text: "Support Us!",
                      buyMeACoffeeName: "rachelmark",
                      color: BuyMeACoffeeColor.Grey,
                    ),


// check other apps
                    ElevatedButton(
                      onPressed: () async {
                        //gameRef.overlays.remove(MainMenu.id);
                        const url = 'https://play.google.com/store/apps/developer?id=Puzzle+Pixel+Studio';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },

                      child: const Text(
                        'Check Other Apps',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),

                    // about
                    ElevatedButton(
                      onPressed: () async {
                        const url = 'https://www.ppixel.online/rabbit-run'; // Your URL
                        final Uri uri = Uri.parse(url); // Convert URL to Uri object

                        // Check if the URL can be launched
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication); // Open in default browser
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
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
