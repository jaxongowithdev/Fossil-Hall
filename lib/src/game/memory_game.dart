import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../data/player_data.dart';
import 'card_component.dart';
import 'game_theme.dart';

class ExcavationGame extends FlameGame with TapCallbacks {
  final PlayerData playerData;
  final DigSite digSite;
  final void Function(int energy) onEnergyChanged;
  final void Function(String fossilName, int dinoId, String part) onFossilFound;

  ExcavationGame({
    required this.playerData,
    required this.digSite,
    required this.onEnergyChanged,
    required this.onFossilFound,
  });

  static const int rows = GameConfig.gridRows;
  static const int cols = GameConfig.gridCols;

  final List<BlockComponent> _blocks = [];
  final Random _random = Random();
  int _currentEnergy = 0;

  @override
  Color backgroundColor() => GameConfig.backgroundColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _currentEnergy = playerData.energy;
    _setupGrid();
  }

  void _setupGrid() {
    _blocks.clear();
    removeAll(children);

    final double padding = 8;
    final double availableWidth = size.x - padding * 2;
    final double availableHeight = size.y - padding * 2;
    final double blockWidth = (availableWidth - (cols - 1) * GameConfig.blockPadding) / cols;
    final double blockHeight = (availableHeight - (rows - 1) * GameConfig.blockPadding) / rows;
    final double blockSize = min(blockWidth, blockHeight);

    final double totalGridWidth = cols * blockSize + (cols - 1) * GameConfig.blockPadding;
    final double totalGridHeight = rows * blockSize + (rows - 1) * GameConfig.blockPadding;
    final double offsetX = (size.x - totalGridWidth) / 2;
    final double offsetY = (size.y - totalGridHeight) / 2;

    // Increase fossil spawn rate: 10-15 fossils per grid (12.5%-18.75%)
    final fossilCount = 10 + _random.nextInt(6);
    final fossilPositions = <int>{};
    while (fossilPositions.length < fossilCount) {
      fossilPositions.add(_random.nextInt(rows * cols));
    }

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final int index = row * cols + col;
        final double x = offsetX + col * (blockSize + GameConfig.blockPadding);
        final double y = offsetY + row * (blockSize + GameConfig.blockPadding);

        final blockType = _getRandomBlockType(row);
        final hasFossil = fossilPositions.contains(index);

        final block = BlockComponent(
          blockType: blockType,
          row: row,
          col: col,
          position: Vector2(x, y),
          size: Vector2(blockSize, blockSize),
          onTap: _onBlockTapped,
        );

        if (hasFossil) {
          block.hasFossil = true;
          final availableDinos = digSite.availableDinosaurs;
          final dinoId = availableDinos[_random.nextInt(availableDinos.length)];
          final dino = Dinosaur.all.firstWhere((d) => d.id == dinoId);
          final fossilPart = dino.fossilParts[_random.nextInt(dino.fossilParts.length)];

          block.fossilDinoId = dinoId;
          block.fossilPart = fossilPart;
        }

        _blocks.add(block);
        add(block);
      }
    }
  }

  BlockType _getRandomBlockType(int row) {
    final depth = row / rows;

    if (depth < 0.2) {
      return BlockType.soil;
    } else if (depth < 0.4) {
      return _random.nextDouble() < 0.7 ? BlockType.rock : BlockType.soil;
    } else if (depth < 0.6) {
      final rand = _random.nextDouble();
      if (rand < 0.5) return BlockType.rock;
      if (rand < 0.8) return BlockType.hardRock;
      return BlockType.fossilRock;
    } else if (depth < 0.8) {
      final rand = _random.nextDouble();
      if (rand < 0.3) return BlockType.hardRock;
      if (rand < 0.6) return BlockType.fossilRock;
      return BlockType.crystalRock;
    } else {
      final rand = _random.nextDouble();
      if (rand < 0.2) return BlockType.lavaRock;
      if (rand < 0.5) return BlockType.ancientStone;
      if (rand < 0.8) return BlockType.crystalRock;
      return BlockType.hardRock;
    }
  }

  void _onBlockTapped(BlockComponent block) {
    if (block.isExcavated) return;

    final blockData = BlockData.getBlockData(block.blockType);
    final energyCost = blockData.energyCost;

    if (_currentEnergy < energyCost) {
      return;
    }

    _currentEnergy -= energyCost;
    onEnergyChanged(_currentEnergy);

    final tool = playerData.tools[ToolType.pickaxe]!;
    final damage = tool.power;
    block.takeDamage(damage);

    // Track excavation for daily missions
    if (block.isExcavated) {
      playerData.incrementMission('excavate_blocks');
    }

    if (block.isExcavated && block.hasFossil) {
      final dino = Dinosaur.all.firstWhere((d) => d.id == block.fossilDinoId);
      onFossilFound(dino.name, block.fossilDinoId!, block.fossilPart!);
      playerData.discoverFossil(block.fossilDinoId!, block.fossilPart!);
      playerData.addCoins(50);
      playerData.addExperience(25);

      // Track fossil discovery for daily missions
      playerData.incrementMission('find_fossils');
    }
  }

  void reset() {
    _setupGrid();
    _currentEnergy = playerData.energy;
  }
}
