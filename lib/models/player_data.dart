import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 500;

  int get lives => _lives;
  set lives(int value) {
    if (value <= 500 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }





   int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    // Check if score exceeds 100 and progress to stage 2
    if (_currentScore >= 100) {
      progressToStage2();
    }


    notifyListeners();
    save();
  }

  void progressToStage2() {
    // Logic to progress to stage 2
    // This can include updating the current stage in the game or any other relevant logic.
    // For example:
     //gameRef.setCurrentStage(2);
  }

}
