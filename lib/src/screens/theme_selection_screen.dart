import 'package:flutter/material.dart';
import '../data/player_data.dart';
import '../data/game_data.dart';

class HomeScreen extends StatelessWidget {
  final PlayerData playerData;
  final Function(String screen) onNavigate;

  const HomeScreen({
    super.key,
    required this.playerData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsBar(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildStartExpeditionButton(context),
                  const SizedBox(height: 20),
                  _buildQuickActionsGrid(context),
                  const SizedBox(height: 20),
                  _buildDailyMissions(),
                  const SizedBox(height: 20),
                  _buildProgressSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Fossil Hall',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dig • Discover • Restore • Exhibit',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final energyPercent = playerData.energy / playerData.maxEnergy;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('Level', '${playerData.level}', '🏆'),
              GestureDetector(
                onTap: () {
                  if (playerData.energy < playerData.maxEnergy) {
                    playerData.restoreEnergy(20);
                  }
                },
                child: _statItem(
                  'Energy',
                  '${playerData.energy}/${playerData.maxEnergy}',
                  '⚡',
                ),
              ),
              _statItem('Coins', '${playerData.coins}', '💰'),
              _statItem('Rank', '${playerData.museumRank}', '⭐'),
            ],
          ),
          if (energyPercent < 1.0) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: energyPercent,
                backgroundColor: const Color(0xFF3E3E3E),
                valueColor: AlwaysStoppedAnimation(
                  energyPercent > 0.5 ? Colors.green : Colors.orange,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '⚡ Tap Energy to restore +20 | Auto-regen: 1/5min',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStartExpeditionButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onNavigate('dig_site'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D5016), Color(0xFF4A7C2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D5016).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Text(
              'Start Expedition',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {'icon': '🏛️', 'label': 'Museum', 'screen': 'museum'},
      {'icon': '🔬', 'label': 'Research', 'screen': 'research'},
      {'icon': '🔧', 'label': 'Workshop', 'screen': 'workshop'},
      {'icon': '🦴', 'label': 'Boosts', 'screen': 'cards'},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () => onNavigate(action['screen'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3E3E3E)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(action['icon'] as String, style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyMissions() {
    final blocksMission = playerData.getMissionProgress('excavate_blocks');
    final fossilsMission = playerData.getMissionProgress('find_fossils');
    final coinsMission = playerData.getMissionProgress('spend_coins');

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
            'Daily Missions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _missionItem('Excavate 50 blocks', blocksMission, 50),
          _missionItem('Find 3 fossils', fossilsMission, 3),
          _missionItem('Spend 500 coins', coinsMission, 500),
        ],
      ),
    );
  }

  Widget _missionItem(String title, int current, int total) {
    final progress = (current / total).clamp(0.0, 1.0);
    final isComplete = current >= total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ),
              if (isComplete)
                const Icon(Icons.check_circle, color: Color(0xFF4A7C2C), size: 20)
              else
                Text(
                  '$current/$total',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF3E3E3E),
              valueColor: AlwaysStoppedAnimation(
                isComplete ? const Color(0xFF4A7C2C) : const Color(0xFFD2691E),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final completedCount = playerData.completedDinosaurs.length;
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
            'Collection Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dinosaurs: $completedCount/${Dinosaur.all.length}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completedCount / Dinosaur.all.length,
              backgroundColor: const Color(0xFF3E3E3E),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFD2691E)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
