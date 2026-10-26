import 'package:flutter/material.dart';

enum DinoRarity { common, uncommon, rare, epic, legendary }

enum DinoEra { triassic, jurassic, cretaceous }

enum DinoDiet { carnivore, herbivore, omnivore }

enum BlockType {
  soil,
  rock,
  hardRock,
  fossilRock,
  crystalRock,
  lavaRock,
  ancientStone,
}

enum ToolType {
  brush,
  shovel,
  pickaxe,
  scanner,
  drill,
  hammer,
  vacuum,
}

enum CardSuit { spades, hearts, diamonds, clubs }

enum CardEffect {
  miningSpeedBoost,
  pickaxePowerBoost,
  scannerRangeBoost,
  instantBreak,
  unlimitedEnergy,
  energyRecover,
  repairTool,
  rareFossilBoost,
  revealHidden,
  doubleCoin,
  freezeTimer,
  extraBackpack,
  autoBrush,
  extraRewards,
}

class Dinosaur {
  final int id;
  final String name;
  final DinoRarity rarity;
  final DinoEra era;
  final DinoDiet diet;
  final double height;
  final double weight;
  final String location;
  final String description;
  final List<String> fossilParts;
  final int displayValue;

  const Dinosaur({
    required this.id,
    required this.name,
    required this.rarity,
    required this.era,
    required this.diet,
    required this.height,
    required this.weight,
    required this.location,
    required this.description,
    required this.fossilParts,
    required this.displayValue,
  });

  static const List<Dinosaur> all = [
    Dinosaur(
      id: 1,
      name: 'Tyrannosaurus Rex',
      rarity: DinoRarity.legendary,
      era: DinoEra.cretaceous,
      diet: DinoDiet.carnivore,
      height: 6.0,
      weight: 9000,
      location: 'North America',
      description: 'The king of dinosaurs, one of the largest land carnivores',
      fossilParts: ['skull', 'jaw', 'ribs', 'spine', 'leg', 'arm', 'tail'],
      displayValue: 10000,
    ),
    Dinosaur(
      id: 2,
      name: 'Velociraptor',
      rarity: DinoRarity.epic,
      era: DinoEra.cretaceous,
      diet: DinoDiet.carnivore,
      height: 0.5,
      weight: 15,
      location: 'Mongolia',
      description: 'Swift and intelligent pack hunter',
      fossilParts: ['skull', 'claws', 'spine', 'leg', 'tail'],
      displayValue: 5000,
    ),
    Dinosaur(
      id: 3,
      name: 'Triceratops',
      rarity: DinoRarity.rare,
      era: DinoEra.cretaceous,
      diet: DinoDiet.herbivore,
      height: 3.0,
      weight: 6000,
      location: 'North America',
      description: 'Three-horned herbivore with a large frill',
      fossilParts: ['skull', 'horns', 'frill', 'spine', 'leg'],
      displayValue: 4000,
    ),
    Dinosaur(
      id: 4,
      name: 'Stegosaurus',
      rarity: DinoRarity.rare,
      era: DinoEra.jurassic,
      diet: DinoDiet.herbivore,
      height: 4.0,
      weight: 5000,
      location: 'North America',
      description: 'Distinctive with plates along its back',
      fossilParts: ['skull', 'plates', 'spine', 'leg', 'tail spikes'],
      displayValue: 3500,
    ),
    Dinosaur(
      id: 5,
      name: 'Brachiosaurus',
      rarity: DinoRarity.epic,
      era: DinoEra.jurassic,
      diet: DinoDiet.herbivore,
      height: 13.0,
      weight: 56000,
      location: 'North America',
      description: 'One of the tallest dinosaurs with long neck',
      fossilParts: ['skull', 'neck', 'spine', 'ribs', 'leg'],
      displayValue: 7000,
    ),
  ];
}

class Tool {
  final ToolType type;
  final int level;
  final int power;
  final double speed;
  final int upgradeCost;

  const Tool({
    required this.type,
    required this.level,
    required this.power,
    required this.speed,
    required this.upgradeCost,
  });

  String get name {
    switch (type) {
      case ToolType.brush:
        return 'Brush';
      case ToolType.shovel:
        return 'Shovel';
      case ToolType.pickaxe:
        return 'Pickaxe';
      case ToolType.scanner:
        return 'Scanner';
      case ToolType.drill:
        return 'Drill';
      case ToolType.hammer:
        return 'Hammer';
      case ToolType.vacuum:
        return 'Vacuum';
    }
  }

  String get icon {
    switch (type) {
      case ToolType.brush:
        return '🖌️';
      case ToolType.shovel:
        return '🗡️';
      case ToolType.pickaxe:
        return '⛏️';
      case ToolType.scanner:
        return '📡';
      case ToolType.drill:
        return '🔧';
      case ToolType.hammer:
        return '🔨';
      case ToolType.vacuum:
        return '🌀';
    }
  }
}

class SupportCard {
  final String assetName;
  final CardSuit suit;
  final String rank;
  final CardEffect effect;
  final int value;
  final int level;
  final int cooldown;

  const SupportCard({
    required this.assetName,
    required this.suit,
    required this.rank,
    required this.effect,
    required this.value,
    required this.level,
    required this.cooldown,
  });

  String get name {
    final tier = switch (rank) {
      'ace' => 'Prime',
      'king' => 'Grand',
      'queen' => 'Elite',
      'jack' => 'Pro',
      '10' => 'Advanced',
      '9' || '8' => 'Skilled',
      _ => 'Field',
    };
    return switch (effect) {
      CardEffect.miningSpeedBoost => '$tier Dig Speed',
      CardEffect.pickaxePowerBoost => '$tier Pick Power',
      CardEffect.scannerRangeBoost => '$tier Scanner',
      CardEffect.instantBreak => 'Instant Break',
      CardEffect.unlimitedEnergy => 'Endless Energy',
      CardEffect.energyRecover => '$tier Energy Restore',
      CardEffect.repairTool => '$tier Tool Repair',
      CardEffect.rareFossilBoost => '$tier Fossil Radar',
      CardEffect.revealHidden => 'Hidden Reveal',
      CardEffect.doubleCoin => 'Double Rewards',
      CardEffect.freezeTimer => '$tier Time Freeze',
      CardEffect.extraBackpack => '$tier Extra Pack',
      CardEffect.autoBrush => 'Auto Excavator',
      CardEffect.extraRewards => '$tier Bonus Find',
    };
  }

  String get description {
    switch (effect) {
      case CardEffect.miningSpeedBoost:
        return 'Mining Speed +$value%';
      case CardEffect.pickaxePowerBoost:
        return 'Pickaxe Power +$value%';
      case CardEffect.scannerRangeBoost:
        return 'Scanner Range +$value%';
      case CardEffect.instantBreak:
        return 'Instantly break any rock';
      case CardEffect.unlimitedEnergy:
        return 'Unlimited energy for 60s';
      case CardEffect.energyRecover:
        return 'Recover $value energy';
      case CardEffect.repairTool:
        return 'Repair tool durability +$value%';
      case CardEffect.rareFossilBoost:
        return 'Rare fossil chance +$value%';
      case CardEffect.revealHidden:
        return 'Reveal hidden fossils';
      case CardEffect.doubleCoin:
        return 'Double coin rewards';
      case CardEffect.freezeTimer:
        return 'Freeze time for $value seconds';
      case CardEffect.extraBackpack:
        return 'Extra backpack slots +$value';
      case CardEffect.autoBrush:
        return 'Auto-brush fossils';
      case CardEffect.extraRewards:
        return 'Extra rewards +$value%';
    }
  }

  static List<SupportCard> generateDeck() {
    final List<SupportCard> cards = [];
    final suits = [CardSuit.spades, CardSuit.hearts, CardSuit.diamonds, CardSuit.clubs];
    final ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king', 'ace'];

    for (var suit in suits) {
      for (var rank in ranks) {
        final assetName = '${rank}_of_${suit.name}.svg';
        final effect = _getEffectForCard(suit, rank);
        final value = _getValueForCard(rank);

        cards.add(SupportCard(
          assetName: assetName,
          suit: suit,
          rank: rank,
          effect: effect,
          value: value,
          level: 1,
          cooldown: 60,
        ));
      }
    }
    return cards;
  }

  static CardEffect _getEffectForCard(CardSuit suit, String rank) {
    switch (suit) {
      case CardSuit.spades:
        if (rank == 'queen') return CardEffect.instantBreak;
        if (rank == 'ace') return CardEffect.unlimitedEnergy;
        return rank == '2' || rank == '3'
            ? CardEffect.miningSpeedBoost
            : CardEffect.pickaxePowerBoost;
      case CardSuit.hearts:
        return rank == '2' || rank == '3'
            ? CardEffect.energyRecover
            : CardEffect.repairTool;
      case CardSuit.diamonds:
        if (rank == 'king') return CardEffect.doubleCoin;
        return rank == '2' || rank == '3'
            ? CardEffect.rareFossilBoost
            : CardEffect.revealHidden;
      case CardSuit.clubs:
        if (rank == 'ace') return CardEffect.autoBrush;
        return rank == '2' || rank == '3'
            ? CardEffect.freezeTimer
            : CardEffect.extraBackpack;
    }
  }

  static int _getValueForCard(String rank) {
    switch (rank) {
      case '2':
        return 10;
      case '3':
        return 15;
      case '4':
        return 20;
      case '5':
        return 25;
      case '6':
        return 30;
      case '7':
        return 35;
      case '8':
        return 40;
      case '9':
        return 45;
      case '10':
        return 50;
      case 'jack':
        return 60;
      case 'queen':
        return 70;
      case 'king':
        return 80;
      case 'ace':
        return 100;
      default:
        return 10;
    }
  }
}

class DigSite {
  final int id;
  final String name;
  final String location;
  final String icon;
  final DinoEra era;
  final int unlockLevel;
  final int energyCost;
  final List<int> availableDinosaurs;

  const DigSite({
    required this.id,
    required this.name,
    required this.location,
    required this.icon,
    required this.era,
    required this.unlockLevel,
    required this.energyCost,
    required this.availableDinosaurs,
  });

  static const List<DigSite> all = [
    DigSite(
      id: 1,
      name: 'Forest Valley',
      location: 'North America',
      icon: '🌲',
      era: DinoEra.jurassic,
      unlockLevel: 1,
      energyCost: 10,
      availableDinosaurs: [1, 2, 3],
    ),
    DigSite(
      id: 2,
      name: 'Desert Canyon',
      location: 'Africa',
      icon: '🏜️',
      era: DinoEra.cretaceous,
      unlockLevel: 5,
      energyCost: 15,
      availableDinosaurs: [2, 3, 4],
    ),
    DigSite(
      id: 3,
      name: 'Mountain Peak',
      location: 'Asia',
      icon: '⛰️',
      era: DinoEra.jurassic,
      unlockLevel: 10,
      energyCost: 20,
      availableDinosaurs: [1, 4, 5],
    ),
    DigSite(
      id: 4,
      name: 'Ice Cavern',
      location: 'Antarctica',
      icon: '❄️',
      era: DinoEra.cretaceous,
      unlockLevel: 15,
      energyCost: 25,
      availableDinosaurs: [1, 2, 5],
    ),
    DigSite(
      id: 5,
      name: 'Volcanic Island',
      location: 'Pacific',
      icon: '🌋',
      era: DinoEra.triassic,
      unlockLevel: 20,
      energyCost: 30,
      availableDinosaurs: [1, 3, 4, 5],
    ),
  ];
}

class BlockData {
  final BlockType type;
  final int durability;
  final int energyCost;
  final Color color;

  const BlockData({
    required this.type,
    required this.durability,
    required this.energyCost,
    required this.color,
  });

  static BlockData getBlockData(BlockType type) {
    switch (type) {
      case BlockType.soil:
        return const BlockData(
          type: BlockType.soil,
          durability: 1,
          energyCost: 1,
          color: Color(0xFF8B4513),
        );
      case BlockType.rock:
        return const BlockData(
          type: BlockType.rock,
          durability: 3,
          energyCost: 2,
          color: Color(0xFF696969),
        );
      case BlockType.hardRock:
        return const BlockData(
          type: BlockType.hardRock,
          durability: 5,
          energyCost: 3,
          color: Color(0xFF2F4F4F),
        );
      case BlockType.fossilRock:
        return const BlockData(
          type: BlockType.fossilRock,
          durability: 4,
          energyCost: 2,
          color: Color(0xFFD2691E),
        );
      case BlockType.crystalRock:
        return const BlockData(
          type: BlockType.crystalRock,
          durability: 6,
          energyCost: 4,
          color: Color(0xFF4169E1),
        );
      case BlockType.lavaRock:
        return const BlockData(
          type: BlockType.lavaRock,
          durability: 7,
          energyCost: 5,
          color: Color(0xFFFF4500),
        );
      case BlockType.ancientStone:
        return const BlockData(
          type: BlockType.ancientStone,
          durability: 10,
          energyCost: 6,
          color: Color(0xFF4B0082),
        );
    }
  }
}
