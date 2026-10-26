import 'package:flutter/material.dart';

class GameConfig {
  static const int gridRows = 10;
  static const int gridCols = 8;
  static const int maxEnergy = 100;
  static const int energyRegenRate = 1;
  static const int energyRegenInterval = 300;

  static const Color primaryColor = Color(0xFF2D5016);
  static const Color secondaryColor = Color(0xFF8B4513);
  static const Color accentColor = Color(0xFFD2691E);
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color surfaceColor = Color(0xFF2A2A2A);

  static const double blockSize = 40.0;
  static const double blockPadding = 2.0;

  static const int maxDeckSize = 5;
  static const int maxBackpackSlots = 20;

  static const Map<int, int> levelExperienceRequirements = {
    1: 100,
    2: 200,
    3: 350,
    4: 550,
    5: 800,
    6: 1100,
    7: 1500,
    8: 2000,
    9: 2600,
    10: 3300,
  };

  static int getExperienceForLevel(int level) {
    return levelExperienceRequirements[level] ?? (level * 100);
  }
}
