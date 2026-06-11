import '../game/enemy.dart';


class EnemyList {
  late List<Enemy> _enemies;

  EnemyList() {
    _enemies = [];
  }

  // Method to add an enemy to the list
  void addEnemy(Enemy enemy) {
    _enemies.add(enemy);
  }

  // Method to remove an enemy from the list
  void removeEnemy(Enemy enemy) {
    _enemies.remove(enemy);
  }

  // Method to retrieve all enemies in the list
  List<Enemy> getAllEnemies() {
    return List<Enemy>.from(_enemies);
  }

  // Method to clear all enemies from the list
  void clearEnemies() {
    _enemies.clear();
  }
}
