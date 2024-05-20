import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 5;

  int get lives => _lives;
  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }




  int _currentlevel =1 ;
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

  int get currentlevel => _currentlevel ;
  set currentlevel(int value) {
    _currentlevel = value;

    notifyListeners();
    save();
  }


}




// import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
// part 'player_data.g.dart';
//
// // This class stores the player progress presistently.
// @HiveType(typeId: 0)
// class PlayerData extends ChangeNotifier with HiveObjectMixin {
//   @HiveField(1)
//   int highScore = 0;
//
//   int _lives = 5;
//
//   int get lives => _lives;
//   set lives(int value) {
//     if (value <= 5 && value >= 0) {
//       _lives = value;
//       notifyListeners();
//     }
//   }
//
//
//
//
//   int _currentlevel =1 ;
//    int _currentscore = 0;
//
//   int get currentscore => _currentscore;
//   set currentscore(int value) {
//     _currentlevel = value;
//
//     if (highScore < _currentscore) {
//       highScore = _currentscore;
//     }
//
//     // Check if score exceeds 100 and progress to stage 2
//     // if (_currentScore >= 100) {
//     //   progressToStage2();
//     // }
//     //
//
//     notifyListeners();
//     save();
//   }
//
//   int get currentlevel => _currentlevel ;
//   set currentlevel(int value) {
//     _currentlevel = value;
//
//     notifyListeners();
//     save();
//   }
//   // void progressToStage2() {
//   //   // Logic to progress to stage 2
//   //   // This can include updating the current stage in the game or any other relevant logic.
//   //   // For example:
//   //    //gameRef.setCurrentStage(2);
//   // }
//
// }
