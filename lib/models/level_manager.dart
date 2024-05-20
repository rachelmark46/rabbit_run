import 'package:flame/components.dart';
import '../game/rabbit_run.dart';

class LevelManager extends Component with HasGameRef<RabbitRun> {
  LevelManager({required this.level});

  // int selectedLevel; // level that the player selects at the beginning
  int level; // current level
  // Configurations for different levels of difficulty
  final Map<int, LevelConfig> levelsConfig = {
    1: const LevelConfig(
      background: '_parallaxBackgroundStage1',
      enemies: [
        'AngryPig/Walk (36x30).png',
        'Bat/Flying (46x30).png',
        'Rino/Run (52x34).png'
      ],
      scoreThreshold: 20,
    ),
    2: const LevelConfig(
      background: '_parallaxBackgroundStage2',
      enemies: [
        'Bee/Attack (36x34).png', 'Rocks/Rock1_Run (38x34).png',
        //'Chameleon/Run (84x38).png',
        'BlueBird/Flying (32x32).png'
      ],
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

  bool shouldLevelUp(int currentscore) {
    print(currentscore);
    print("player score ");
    if (currentscore >= 20) {
      if (levelsConfig.containsKey(level)) {
        return levelsConfig[level]!.scoreThreshold == currentscore;
      }

      return true;
    } else {
      return false;
    }
  }

  void increaseLevel() {
    //if (level < levelsConfig.keys.length) {
    if (level == 1) {
      // Add bonus score for crossing from level 1 to level 2
      // print (gameRef.playerData.currentScore);
      // gameRef.playerData.currentScore += 50;
      level++;
      print("new level ");
      print(level);
    }
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
