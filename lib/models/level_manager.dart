import 'package:flame/components.dart';

import '../game/rabbit_run.dart';

class LevelManager extends Component with HasGameRef<RabbitRun> {
  LevelManager({this.selectedLevel = 1, this.level = 1});

  int selectedLevel; // level that the player selects at the beginning
  int level; // current level
  // Configurations for different levels of difficulty
  final Map<int, LevelConfig> levelsConfig = {
    1: const LevelConfig(
      background: '_parallaxBackgroundStage1',
      enemies: ['AngryPig/Walk (36x30).png','Bat/Flying (46x30).png','Rino/Run (52x34).png' ],
      scoreThreshold: 20,
    ),
    2: const LevelConfig(
      background: '_parallaxBackgroundStage2',
      enemies: ['Bee/Attack (36x34).png','Chameleon/Run (84x38).png', 'BlueBird/Flying (32x32).png'],
      scoreThreshold: 150,
    ),
    // Add more levels as needed
  };

  String get background {
    return levelsConfig[level]!.background;
  }

  List<String> get enemies {
    return levelsConfig[level]!.enemies;
  }

  int get scoreThreshold {
    return levelsConfig[level]!.scoreThreshold;
  }

  // bool shouldLevelUp(int score) {
  //   if (score >= 20) {
  //     int nextLevel = level + 1;
  //
  //     if (levelsConfig.containsKey(nextLevel)) {
  //       return levelsConfig[nextLevel]!.scoreThreshold == score;
  //     }
  //     return true ;
  //   }
  //   else
  //   return false;
  // }
  bool shouldLevelUp(int currentscore) {

//      int nextLevel = level + 1;
    print(currentscore);
    print("player score ");
    if (currentscore >= 20) {
      //int nextLevel = level + 1;
      print("level" );
      print(level);
      //print(nextLevel);
      if (levelsConfig.containsKey(level)) {
        return levelsConfig[level]!.scoreThreshold == currentscore;
      }
      // if (levelsConfig.containsKey(nextLevel)) {
      //   return levelsConfig[nextLevel]!.scoreThreshold == score;
      // }
      return true;
    }
    else{
      return false;}
  }

  List<int> get levels {
    return levelsConfig.keys.toList();
  }

  void increaseLevel() {
    //if (level < levelsConfig.keys.length) {
      if (level == 1) {
        // Add bonus score for crossing from level 1 to level 2
        // print (gameRef.playerData.currentScore);
        // gameRef.playerData.currentScore += 50;

      level++;

      print("new level ");
      print(level );
    }
  }

  void setLevel(int newLevel) {
    if (levelsConfig.containsKey(newLevel)) {
      level = newLevel;
    }
  }

  void selectLevel(int selectLevel) {
    if (levelsConfig.containsKey(selectLevel)) {
      selectedLevel = selectLevel;
    }
  }

  void reset() {
    level = selectedLevel;
  }
}

class LevelConfig {
  final String background;
  final List<String> enemies;
  final int scoreThreshold;

  const LevelConfig({
    required this.background,
    required this.enemies,
    required this.scoreThreshold,
  });
}
