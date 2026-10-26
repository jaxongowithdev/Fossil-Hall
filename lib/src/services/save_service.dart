import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/player_data.dart';
import '../data/game_data.dart';

class SaveService {
  static const String _keyPlayerLevel = 'player_level';
  static const String _keyPlayerExp = 'player_exp';
  static const String _keyPlayerCoins = 'player_coins';
  static const String _keyPlayerEnergy = 'player_energy';
  static const String _keyPlayerMaxEnergy = 'player_max_energy';
  static const String _keyMuseumRank = 'museum_rank';
  static const String _keyTools = 'tools';
  static const String _keyOwnedCards = 'owned_cards';
  static const String _keySelectedDeck = 'selected_deck';
  static const String _keyDiscoveredFossils = 'discovered_fossils';
  static const String _keyCompletedDinos = 'completed_dinos';
  static const String _keyUnlockedSites = 'unlocked_sites';
  static const String _keyDailyMissions = 'daily_missions';
  static const String _keyLastSaveDate = 'last_save_date';

  /// Save all player data
  static Future<bool> saveGame(PlayerData playerData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_keyPlayerLevel, playerData.level);
      await prefs.setInt(_keyPlayerExp, playerData.experience);
      await prefs.setInt(_keyPlayerCoins, playerData.coins);
      await prefs.setInt(_keyPlayerEnergy, playerData.energy);
      await prefs.setInt(_keyPlayerMaxEnergy, playerData.maxEnergy);
      await prefs.setInt(_keyMuseumRank, playerData.museumRank);

      // Save tools
      final toolsJson = jsonEncode(
        playerData.tools.map((key, value) => MapEntry(
          key.name,
          {
            'level': value.level,
            'power': value.power,
            'speed': value.speed,
            'upgradeCost': value.upgradeCost,
          },
        )),
      );
      await prefs.setString(_keyTools, toolsJson);

      // Save owned cards (just asset names)
      final cardsJson = jsonEncode(
        playerData.ownedCards.map((c) => c.assetName).toList(),
      );
      await prefs.setString(_keyOwnedCards, cardsJson);

      // Save selected deck
      final deckJson = jsonEncode(
        playerData.selectedDeck.map((c) => c.assetName).toList(),
      );
      await prefs.setString(_keySelectedDeck, deckJson);

      // Save discovered fossils (convert int keys to strings)
      final fossilsMap = <String, dynamic>{};
      playerData.discoveredFossils.forEach((key, value) {
        fossilsMap[key.toString()] = value;
      });
      final fossilsJson = jsonEncode(fossilsMap);
      await prefs.setString(_keyDiscoveredFossils, fossilsJson);

      // Save completed dinosaurs
      await prefs.setString(_keyCompletedDinos, jsonEncode(playerData.completedDinosaurs));

      // Save unlocked sites
      await prefs.setString(_keyUnlockedSites, jsonEncode(playerData.unlockedSites));

      // Save daily missions (already String keys, should be fine)
      final missionsJson = jsonEncode(playerData.dailyMissions);
      await prefs.setString(_keyDailyMissions, missionsJson);

      // Save timestamp
      await prefs.setString(_keyLastSaveDate, DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      print('Error saving game: $e');
      return false;
    }
  }

  /// Load all player data
  static Future<PlayerData?> loadGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if save exists
      if (!prefs.containsKey(_keyPlayerLevel)) {
        return null;
      }

      final playerData = PlayerData();

      // Load basic stats
      playerData.setLevel(prefs.getInt(_keyPlayerLevel) ?? 1);
      playerData.setExperience(prefs.getInt(_keyPlayerExp) ?? 0);
      playerData.setCoins(prefs.getInt(_keyPlayerCoins) ?? 1000);
      playerData.setEnergy(prefs.getInt(_keyPlayerEnergy) ?? 100);
      playerData.setMaxEnergy(prefs.getInt(_keyPlayerMaxEnergy) ?? 100);
      playerData.setMuseumRank(prefs.getInt(_keyMuseumRank) ?? 1);

      // Load tools
      final toolsJson = prefs.getString(_keyTools);
      if (toolsJson != null) {
        final toolsMap = jsonDecode(toolsJson) as Map<String, dynamic>;
        for (var entry in toolsMap.entries) {
          final toolType = ToolType.values.firstWhere(
            (t) => t.name == entry.key,
            orElse: () => ToolType.brush,
          );
          final toolData = entry.value as Map<String, dynamic>;
          playerData.setTool(
            toolType,
            Tool(
              type: toolType,
              level: toolData['level'] as int,
              power: toolData['power'] as int,
              speed: (toolData['speed'] as num).toDouble(),
              upgradeCost: toolData['upgradeCost'] as int,
            ),
          );
        }
      }

      // Load owned cards
      final cardsJson = prefs.getString(_keyOwnedCards);
      if (cardsJson != null) {
        final cardAssets = List<String>.from(jsonDecode(cardsJson));
        final allCards = SupportCard.generateDeck();
        playerData.clearOwnedCards();
        for (var assetName in cardAssets) {
          final card = allCards.firstWhere(
            (c) => c.assetName == assetName,
            orElse: () => allCards.first,
          );
          playerData.addCard(card);
        }
      }

      // Load selected deck
      final deckJson = prefs.getString(_keySelectedDeck);
      if (deckJson != null) {
        final deckAssets = List<String>.from(jsonDecode(deckJson));
        final allCards = SupportCard.generateDeck();
        playerData.clearDeck();
        for (var assetName in deckAssets) {
          final card = allCards.firstWhere(
            (c) => c.assetName == assetName,
            orElse: () => allCards.first,
          );
          playerData.selectCardForDeck(card);
        }
      }

      // Load discovered fossils
      final fossilsJson = prefs.getString(_keyDiscoveredFossils);
      if (fossilsJson != null) {
        final fossilsData = jsonDecode(fossilsJson) as Map<String, dynamic>;
        for (var entry in fossilsData.entries) {
          final dinoId = int.parse(entry.key);
          final parts = Map<String, bool>.from(entry.value as Map);
          for (var partEntry in parts.entries) {
            if (partEntry.value) {
              playerData.discoverFossilDirect(dinoId, partEntry.key);
            }
          }
        }
      }

      // Load completed dinosaurs
      final completedJson = prefs.getString(_keyCompletedDinos);
      if (completedJson != null) {
        final completed = List<int>.from(jsonDecode(completedJson));
        playerData.setCompletedDinosaurs(completed);
      }

      // Load unlocked sites
      final sitesJson = prefs.getString(_keyUnlockedSites);
      if (sitesJson != null) {
        final sites = List<int>.from(jsonDecode(sitesJson));
        playerData.setUnlockedSites(sites);
      }

      // Load daily missions
      final missionsJson = prefs.getString(_keyDailyMissions);
      if (missionsJson != null) {
        final missions = Map<String, int>.from(jsonDecode(missionsJson));
        playerData.setDailyMissions(missions);
      }

      return playerData;
    } catch (e) {
      print('Error loading game: $e');
      return null;
    }
  }

  /// Clear all saved data
  static Future<bool> clearSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      print('Error clearing save: $e');
      return false;
    }
  }

  /// Check if save exists
  static Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyPlayerLevel);
  }

  /// Get last save date
  static Future<DateTime?> getLastSaveDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_keyLastSaveDate);
    if (dateStr != null) {
      return DateTime.parse(dateStr);
    }
    return null;
  }
}
