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
              const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                //  const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
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
                //  // support us
                // ElevatedButton(
                //  //  onPressed:()=>
                //  //  {
                //  // // gameRef.overlays.remove(MainMenu.id),
                //  //    BuyMeACoffeeButton(
                //  //      text: "Support Us!",
                //  //      buyMeACoffeeName: "rachelmark",
                //  //      color: BuyMeACoffeeColor.Green,
                //  //    ),
                //  //  },
                //   onPressed: () {
                //     // Show a dialog with the BuyMeACoffeeButton when pressed
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           content: BuyMeACoffeeButton(
                //             text: "Support Us!",
                //             buyMeACoffeeName: "rachelmark",
                //             color: BuyMeACoffeeColor.Green,
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: const Text(
                //     'Support Us',
                //     style: TextStyle(
                //       fontSize: 15,
                //     ),
                //   ),
                // ),
                //

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
    );
  }
}


//
// // Placeholder for the BuyMeACoffeeButton widget
// class BuyMeACoffeeButton extends StatelessWidget {
//   final String text;
//   final String buyMeACoffeeName;
//   final BuyMeACoffeeColor color;
//
//   const BuyMeACoffeeButton({
//     required this.text,
//     required this.buyMeACoffeeName,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           text,
//           style: TextStyle(
//               color: color == BuyMeACoffeeColor.Green
//                   ? Colors.green
//                   : Colors.black),
//         ),
//         const SizedBox(height: 10),
//         // BuyMeACoffee Button
//         const BuyMeACoffeeButton(
//           buyMeACoffeeName: "rachelmark",
//           color: BuyMeACoffeeColor.Green, text: '',
//         ),
//         // ElevatedButton(
//         //  // onPressed: () {
//         //     // // Perform any action, such as launching BuyMeACoffee link
//         //     // Navigator.of(context).pop(); // Close the dialog
//         //     // print('Redirecting to BuyMeACoffee page...');
//         //     // BuyMeACoffee Button
//         //      BuyMeACoffeeButton(
//         //       buyMeACoffeeName: "rachelmark",
//         //       color: BuyMeACoffeeColor.Green,
//         //     ),
//         //   },
//         //   child: const Text('Buy Me a Coffee'),
//         // ),
//       ],
//     );
//   }
// }
