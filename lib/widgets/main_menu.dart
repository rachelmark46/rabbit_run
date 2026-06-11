import 'dart:ui';
import 'package:flutter/material.dart';
import '../game/audio_manager.dart';
import '../game/rabbit_run.dart';
import '/widgets/hud.dart';
import '/widgets/settings_menu.dart';
import 'package:flutter_donation_buttons/donationButtons/buyMeACoffeeButton.dart';
import 'package:url_launcher/url_launcher.dart';

// This represents the main menu overlay.
class MainMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'MainMenu';

  // Reference to parent game.
  final RabbitRun gameRef;

  const MainMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.black.withAlpha(100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    'RABBIT RUN',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      gameRef.overlays.remove(MainMenu.id);
                      gameRef.overlays.add(Hud.id);
                      gameRef.startGamePlay();
                      gameRef.resumeEngine();
                      AudioManager.instance.resumeBgm();
                    },
                    child: const Text(
                      'Play',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),

                  //settings
                  ElevatedButton(
                    onPressed: () {
                      gameRef.overlays.remove(MainMenu.id);
                      gameRef.overlays.add(SettingsMenu.id);
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // buy me a coffee button
                  BuyMeACoffeeButton(
                    text: "Support Us!",
                    buyMeACoffeeName: "rachelmark",
                    color: BuyMeACoffeeColor.Grey,
                  ),

// check other apps
                  ElevatedButton(
                    onPressed: () async {
                      final uri = Uri.parse(
                        'https://play.google.com/store/apps/developer?id=Puzzle+Pixel+Studio',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        throw 'Could not launch $uri';
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
                      const url =
                          'https://www.ppixel.org/rabbit-run'; // Your URL
                      final Uri uri =
                          Uri.parse(url); // Convert URL to Uri object

                      // Check if the URL can be launched
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode
                                .externalApplication); // Open in default browser
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
    );
  }
}
