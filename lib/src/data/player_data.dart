import 'package:flutter/foundation.dart';
import 'game_data.dart';

class PlayerData extends ChangeNotifier {
  int _level = 1;
  int _experience = 0;
  int _coins = 1000;
  int _energy = 100;
  int _maxEnergy = 100;
  int _museumRank = 1;

  final Map<ToolType, Tool> _tools = {
    ToolType.brush: const Tool(
      type: ToolType.brush,
      level: 1,
      power: 10,
      speed: 1.0,
      upgradeCost: 100,
    ),
    ToolType.shovel: const Tool(
      type: ToolType.shovel,
      level: 1,
      power: 15,
      speed: 1.2,
      upgradeCost: 150,
    ),
    ToolType.pickaxe: const Tool(
      type: ToolType.pickaxe,
      level: 1,
      power: 20,
      speed: 0.8,
      upgradeCost: 200,
    ),
    ToolType.scanner: const Tool(
      type: ToolType.scanner,
      level: 1,
      power: 5,
      speed: 2.0,
      upgradeCost: 250,
    ),
    ToolType.drill: const Tool(
      type: ToolType.drill,
      level: 1,
      power: 30,
      speed: 0.5,
      upgradeCost: 300,
    ),
    ToolType.hammer: const Tool(
      type: ToolType.hammer,
      level: 1,
      power: 25,
      speed: 0.9,
      upgradeCost: 200,
    ),
    ToolType.vacuum: const Tool(
      type: ToolType.vacuum,
      level: 1,
      power: 12,
      speed: 1.5,
      upgradeCost: 180,
    ),
  };

  final List<SupportCard> _ownedCards = [];
  final List<SupportCard> _selectedDeck = [];
  final Map<int, Map<String, bool>> _discoveredFossils = {};
  final List<int> _completedDinosaurs = [];
  final List<int> _unlockedSites = [1];

  // Daily missions: mission_id -> current_progress
  final Map<String, int> _dailyMissions = {
    'excavate_blocks': 0,
    'find_fossils': 0,
    'spend_coins': 0,
  };

  int get level => _level;
  int get experience => _experience;
  int get coins => _coins;
  int get energy => _energy;
  int get maxEnergy => _maxEnergy;
  int get museumRank => _museumRank;

  Map<ToolType, Tool> get tools => _tools;
  List<SupportCard> get ownedCards => _ownedCards;
  List<SupportCard> get selectedDeck => _selectedDeck;
  Map<int, Map<String, bool>> get discoveredFossils => _discoveredFossils;
  List<int> get completedDinosaurs => _completedDinosaurs;
  List<int> get unlockedSites => _unlockedSites;
  Map<String, int> get dailyMissions => _dailyMissions;

  PlayerData() {
    _initializeStarterCards();
  }

  void _initializeStarterCards() {
    final allCards = SupportCard.generateDeck();
    _ownedCards.addAll(allCards.take(10));
  }

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  void spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
    }
  }

  void consumeEnergy(int amount) {
    _energy = (_energy - amount).clamp(0, _maxEnergy);
    notifyListeners();
  }

  void restoreEnergy(int amount) {
    _energy = (_energy + amount).clamp(0, _maxEnergy);
    notifyListeners();
  }

  void addExperience(int amount) {
    _experience += amount;
    final expNeeded = _level * 100;
    if (_experience >= expNeeded) {
      _levelUp();
    }
    notifyListeners();
  }

  void _levelUp() {
    _level++;
    _experience = 0;
    _maxEnergy += 10;
    _energy = _maxEnergy;
    notifyListeners();
  }

  void upgradeTool(ToolType type) {
    final tool = _tools[type]!;
    final cost = tool.upgradeCost;
    if (_coins >= cost) {
      _coins -= cost;
      _tools[type] = Tool(
        type: type,
        level: tool.level + 1,
        power: tool.power + 5,
        speed: tool.speed + 0.1,
        upgradeCost: (cost * 1.5).toInt(),
      );
      notifyListeners();
    }
  }

  void addCard(SupportCard card) {
    _ownedCards.add(card);
    notifyListeners();
  }

  void selectCardForDeck(SupportCard card) {
    if (_selectedDeck.length < 5 && !_selectedDeck.contains(card)) {
      _selectedDeck.add(card);
      notifyListeners();
    }
  }

  void removeCardFromDeck(SupportCard card) {
    _selectedDeck.remove(card);
    notifyListeners();
  }

  void discoverFossil(int dinoId, String fossilPart) {
    if (!_discoveredFossils.containsKey(dinoId)) {
      _discoveredFossils[dinoId] = {};
    }
    _discoveredFossils[dinoId]![fossilPart] = true;

    final dino = Dinosaur.all.firstWhere((d) => d.id == dinoId);
    final allPartsFound = dino.fossilParts.every(
      (part) => _discoveredFossils[dinoId]![part] == true,
    );

    if (allPartsFound && !_completedDinosaurs.contains(dinoId)) {
      _completeDinosaur(dinoId);
    }
    notifyListeners();
  }

  void _completeDinosaur(int dinoId) {
    _completedDinosaurs.add(dinoId);
    final dino = Dinosaur.all.firstWhere((d) => d.id == dinoId);
    addCoins(dino.displayValue);
    addExperience(dino.displayValue ~/ 10);
    _updateMuseumRank();
    notifyListeners();
  }

  void _updateMuseumRank() {
    _museumRank = 1 + (_completedDinosaurs.length ~/ 5);
    notifyListeners();
  }

  void unlockSite(int siteId) {
    if (!_unlockedSites.contains(siteId)) {
      _unlockedSites.add(siteId);
      notifyListeners();
    }
  }

  int getFossilProgress(int dinoId) {
    if (!_discoveredFossils.containsKey(dinoId)) return 0;
    final dino = Dinosaur.all.firstWhere((d) => d.id == dinoId);
    final found = dino.fossilParts.where(
      (part) => _discoveredFossils[dinoId]?[part] == true,
    ).length;
    return (found / dino.fossilParts.length * 100).toInt();
  }

  // === SETTERS FOR SAVE/LOAD ===

  void setLevel(int value) {
    _level = value;
  }

  void setExperience(int value) {
    _experience = value;
  }

  void setCoins(int value) {
    _coins = value;
  }

  void setEnergy(int value) {
    _energy = value;
  }

  void setMaxEnergy(int value) {
    _maxEnergy = value;
  }

  void setMuseumRank(int value) {
    _museumRank = value;
  }

  void setTool(ToolType type, Tool tool) {
    _tools[type] = tool;
  }

  void clearOwnedCards() {
    _ownedCards.clear();
  }

  void clearDeck() {
    _selectedDeck.clear();
  }

  void discoverFossilDirect(int dinoId, String fossilPart) {
    if (!_discoveredFossils.containsKey(dinoId)) {
      _discoveredFossils[dinoId] = {};
    }
    _discoveredFossils[dinoId]![fossilPart] = true;
  }

  void setCompletedDinosaurs(List<int> dinos) {
    _completedDinosaurs.clear();
    _completedDinosaurs.addAll(dinos);
  }

  void setUnlockedSites(List<int> sites) {
    _unlockedSites.clear();
    _unlockedSites.addAll(sites);
  }

  void setDailyMissions(Map<String, int> missions) {
    _dailyMissions.clear();
    _dailyMissions.addAll(missions);
  }

  // === DAILY MISSIONS ===

  void updateMission(String missionId, int progress) {
    _dailyMissions[missionId] = progress;
    notifyListeners();
  }

  void incrementMission(String missionId, [int amount = 1]) {
    _dailyMissions[missionId] = (_dailyMissions[missionId] ?? 0) + amount;
    notifyListeners();
  }

  int getMissionProgress(String missionId) {
    return _dailyMissions[missionId] ?? 0;
  }

  void resetDailyMissions() {
    _dailyMissions['excavate_blocks'] = 0;
    _dailyMissions['find_fossils'] = 0;
    _dailyMissions['spend_coins'] = 0;
    notifyListeners();
  }
}
