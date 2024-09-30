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
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    'RABBIT RUN',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),


                  ElevatedButton(
                    onPressed: () {

                      // gameRef.resumeEngine();
                      gameRef.overlays.remove(MainMenu.id);
                      gameRef.overlays.add(Hud.id);
                      gameRef.startGamePlay();
                      gameRef.resumeEngine();
                      //gameRef.startGamePlay();
                      AudioManager.instance.resumeBgm();
                    },
                    child: const Text(
                      'Play',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      gameRef.overlays.remove(MainMenu.id);
                      gameRef.overlays.add(SettingsMenu.id);
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const BuyMeACoffeeButton(
                    text: "Support Us!",
                    buyMeACoffeeName: "rachelmark",
                    color: BuyMeACoffeeColor.Blue,

                    //Allows custom styling

                  ), Center(
              child: new InkWell(
                  child: new Text('About Us', style: TextStyle(
                      fontSize: 20,
                      color:  Colors.white
                  ),),
                  onTap: () => launch('https://www.ppixel.org')
              ),
            ),  Center(
              child: new InkWell(
                  child: new Text('Check other Apps', style: TextStyle(
                    fontSize: 20,
                    color:  Colors.white
                  ),),
                  onTap: () => launch('https://play.google.com/store/apps/developer?id=Puzzle+Pixel+Studio')
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
