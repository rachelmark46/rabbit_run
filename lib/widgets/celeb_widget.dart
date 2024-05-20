import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../game/rabbit_run.dart';

class CelebWidget extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'Congratulations !!';

  // Reference to parent game.
  final RabbitRun gameRef;

  // Properties for confetti customization.
  final int numberOfParticles = 100;
  final Color color = Colors.blue;
  final double width = 20;
  final double height = 20;
  final double maxBlastForce = 20;
  final Duration duration = const Duration(seconds: 3);

  const CelebWidget(this.gameRef, {Key? key}) : super(key: key);

  @override
  _CelebWidgetState createState() => _CelebWidgetState();
}

class _CelebWidgetState extends State<CelebWidget>
    with SingleTickerProviderStateMixin {
  final controllerCenter =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    controllerCenter.play();
  }

  @override
  void dispose() {
    controllerCenter.dispose();
    super.dispose();
  }

  // Method to stop the confetti animation
  void stopConfetti() {
    controllerCenter.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controllerCenter,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        gravity: 0.5,
        emissionFrequency: 0.05,
        numberOfParticles: 30,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
      ),
    );
  }
}
