import 'package:flutter/material.dart';
import '../data/player_data.dart';
import '../data/game_data.dart';

class ProfileScreen extends StatelessWidget {
  final PlayerData playerData;
  final VoidCallback onBack;

  const ProfileScreen({
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
            Text('👤', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Profile', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildStatsSection(),
          const SizedBox(height: 20),
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D5016), Color(0xFF4A7C2C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🦖', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Archaeologist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Level',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${playerData.level}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _statRow('Museum Rank', '⭐ ${playerData.museumRank}'),
          _statRow('Total Coins', '💰 ${playerData.coins}'),
          _statRow('Experience', '🌟 ${playerData.experience}'),
          _statRow('Dinosaurs Found', '🦴 ${playerData.completedDinosaurs.length}'),
          _statRow('Sites Unlocked', '📍 ${playerData.unlockedSites.length}'),
          _statRow('Boosts Owned', '🦴 ${playerData.ownedCards.length}'),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _achievementTile(
            'First Discovery',
            'Find your first fossil',
            '🏆',
            playerData.completedDinosaurs.isNotEmpty,
          ),
          _achievementTile(
            'Collector',
            'Complete 5 dinosaurs',
            '🎖️',
            playerData.completedDinosaurs.length >= 5,
          ),
          _achievementTile(
            'Master Archaeologist',
            'Reach level 10',
            '👑',
            playerData.level >= 10,
          ),
          _achievementTile(
            'Rich Explorer',
            'Accumulate 10,000 coins',
            '💎',
            playerData.coins >= 10000,
          ),
        ],
      ),
    );
  }

  Widget _achievementTile(String title, String description, String icon, bool unlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? const Color(0xFF4A7C2C).withValues(alpha: 0.2)
            : const Color(0xFF3E3E3E).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: unlocked ? const Color(0xFF4A7C2C) : const Color(0xFF3E3E3E),
        ),
      ),
      child: Row(
        children: [
          Text(
            unlocked ? icon : '🔒',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.white54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: unlocked
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
