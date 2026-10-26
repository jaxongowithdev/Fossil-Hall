import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../data/player_data.dart';

class WorkshopScreen extends StatefulWidget {
  final PlayerData playerData;
  final VoidCallback onBack;

  const WorkshopScreen({
    super.key,
    required this.playerData,
    required this.onBack,
  });

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        title: const Row(
          children: [
            Text('🔧', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Workshop', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCoinsDisplay(),
          const SizedBox(height: 20),
          _buildEnergySection(),
          const SizedBox(height: 20),
          const Text(
            'Upgrade Tools',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...ToolType.values.map((type) => _buildToolCard(type)),
        ],
      ),
    );
  }

  Widget _buildCoinsDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💰', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Text(
            '${widget.playerData.coins} Coins',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergySection() {
    final energyPercent = widget.playerData.energy / widget.playerData.maxEnergy;
    final restCost = 50;
    final canRest = widget.playerData.coins >= restCost &&
                    widget.playerData.energy < widget.playerData.maxEnergy;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '⚡ Energy Station',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.playerData.energy}/${widget.playerData.maxEnergy}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: energyPercent,
              backgroundColor: const Color(0xFF3E3E3E),
              valueColor: AlwaysStoppedAnimation(
                energyPercent > 0.5 ? Colors.green : Colors.orange,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canRest
                      ? () {
                          setState(() {
                            widget.playerData.spendCoins(restCost);
                            widget.playerData.restoreEnergy(widget.playerData.maxEnergy);
                            widget.playerData.incrementMission('spend_coins', restCost);
                          });
                        }
                      : null,
                  icon: const Icon(Icons.bedtime, size: 20),
                  label: Text('Rest (${restCost} coins)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7C2C),
                    disabledBackgroundColor: const Color(0xFF3E3E3E),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Restore energy to full. Auto-regen: 1 energy/5min',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(ToolType type) {
    final tool = widget.playerData.tools[type]!;
    final canAfford = widget.playerData.coins >= tool.upgradeCost;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
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
                  color: const Color(0xFF3E3E3E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(tool.icon, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${tool.level}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: canAfford
                    ? () {
                        setState(() {
                          final cost = tool.upgradeCost;
                          widget.playerData.upgradeTool(type);
                          // Track spending for daily missions
                          widget.playerData.incrementMission('spend_coins', cost);
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7C2C),
                  disabledBackgroundColor: const Color(0xFF3E3E3E),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${tool.upgradeCost}',
                      style: TextStyle(
                        color: canAfford ? Colors.white : Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'UPGRADE',
                      style: TextStyle(
                        color: canAfford ? Colors.white : Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statBadge('Power', '${tool.power}', Icons.flash_on),
              const SizedBox(width: 12),
              _statBadge('Speed', '${tool.speed.toStringAsFixed(1)}', Icons.speed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.amber),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
