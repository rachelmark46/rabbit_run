import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 5; // change it to 5

  int get lives => _lives;
  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  int _currentlevel = 1;
  int _currentscore = 0;

  int get currentscore => _currentscore;
  set currentscore(int value) {
    _currentscore = value;

    if (highScore < _currentscore) {
      highScore = _currentscore;
    }

    notifyListeners();
    save();
  }

  int get currentlevel => _currentlevel;
  set currentlevel(int value) {
    _currentlevel = value;

    notifyListeners();
    save();
  }
}
