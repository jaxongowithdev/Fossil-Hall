import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../data/player_data.dart';

class MuseumScreen extends StatelessWidget {
  final PlayerData playerData;
  final VoidCallback onBack;

  const MuseumScreen({
    super.key,
    required this.playerData,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: const Row(
          children: [
            Text('🏛️', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Museum', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMuseumInfo(),
          const SizedBox(height: 20),
          const Text(
            'Dinosaur Collection',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...Dinosaur.all.map((dino) => _buildDinoCard(dino)),
        ],
      ),
    );
  }

  Widget _buildMuseumInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D5016), Color(0xFF4A7C2C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Museum Rank',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '⭐ ${playerData.museumRank}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${playerData.completedDinosaurs.length}/${Dinosaur.all.length} Dinosaurs',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDinoCard(Dinosaur dino) {
    final isCompleted = playerData.completedDinosaurs.contains(dino.id);
    final progress = playerData.getFossilProgress(dino.id);
    final hasDiscoveredAny = progress > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF4A7C2C)
              : hasDiscoveredAny
                  ? const Color(0xFFD2691E).withValues(alpha: 0.5)
                  : const Color(0xFF3E3E3E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF4A7C2C).withValues(alpha: 0.3)
                      : hasDiscoveredAny
                          ? const Color(0xFFD2691E).withValues(alpha: 0.2)
                          : const Color(0xFF3E3E3E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    isCompleted ? '🦴' : hasDiscoveredAny ? '🦕' : '❓',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasDiscoveredAny ? dino.name : '???',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasDiscoveredAny
                          ? dino.location
                          : _getDiscoveryHint(dino.id),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRarityColor(dino.rarity),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dino.rarity.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (!isCompleted && progress > 0) ...[
            const SizedBox(height: 12),
            // Show fossil parts progress
            Text(
              'Fossil Parts Collected:',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: dino.fossilParts.map((part) {
                final discovered = playerData.discoveredFossils[dino.id]?[part] ?? false;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: discovered
                        ? const Color(0xFF4A7C2C).withValues(alpha: 0.3)
                        : const Color(0xFF3E3E3E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: discovered
                          ? const Color(0xFF4A7C2C)
                          : const Color(0xFF5E5E5E),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        discovered ? '✓' : '○',
                        style: TextStyle(
                          color: discovered ? const Color(0xFF4A7C2C) : Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        part,
                        style: TextStyle(
                          color: discovered ? Colors.white : Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: const Color(0xFF3E3E3E),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFD2691E)),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$progress% Complete',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
          if (isCompleted) ...[
            const SizedBox(height: 12),
            Text(
              dino.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoChip('${dino.height}m', Icons.height),
                const SizedBox(width: 8),
                _infoChip('${dino.weight}kg', Icons.scale),
                const SizedBox(width: 8),
                _infoChip(dino.diet.name, Icons.restaurant),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(DinoRarity rarity) {
    switch (rarity) {
      case DinoRarity.common:
        return Colors.grey;
      case DinoRarity.uncommon:
        return Colors.green;
      case DinoRarity.rare:
        return Colors.blue;
      case DinoRarity.epic:
        return Colors.purple;
      case DinoRarity.legendary:
        return Colors.orange;
    }
  }

  String _getDiscoveryHint(int dinoId) {
    // Find which sites have this dinosaur
    final sites = DigSite.all.where((site) => site.availableDinosaurs.contains(dinoId)).toList();

    if (sites.isEmpty) {
      return 'Not discovered';
    }

    // Find lowest level site
    sites.sort((a, b) => a.unlockLevel.compareTo(b.unlockLevel));
    final lowestSite = sites.first;

    final canUnlock = playerData.level >= lowestSite.unlockLevel;
    final isUnlocked = playerData.unlockedSites.contains(lowestSite.id);

    if (isUnlocked) {
      return '🗺️ Found in ${lowestSite.name}';
    } else if (canUnlock) {
      return '🔓 Unlock ${lowestSite.name} (Lv ${lowestSite.unlockLevel})';
    } else {
      return '🔒 Reach Level ${lowestSite.unlockLevel} to unlock';
    }
  }
}
